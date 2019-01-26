(ns mcavoy.components.twitter-client
  (:use [twitter.oauth]
        [twitter.callbacks]
        [twitter.callbacks.handlers]
        [twitter.api.streaming]
        [clj-time.format :as f]
        [mcavoy.api.domain :as domain]
        [mcavoy.components.database :as db]
        [cheshire.core :refer :all])
  (:require [taoensso.timbre :as timbre]
            [jdbc.pool.c3p0]
            [com.stuartsierra.component :as component]
            [http.async.client]
            [taoensso.timbre :as timbre]
            [mcavoy.api.persistence :as persistence]
            [clojure.walk :refer [keywordize-keys]]
            [fulcro.websockets.protocols :as wp])
  (:import [twitter.callbacks.protocols AsyncStreamingCallback]))

(def twitter-date-formatted (f/formatter "EEE MMM dd HH:mm:ss Z YYYY"))

(defn- disseminate-news-report [websockets view-model]
  (try
    (let []
      (let [cids (some-> websockets :connected-uids deref :any)]
        (doseq [cid cids]
          (wp/push websockets cid :tweet-received view-model))))

    (catch Exception e
      (timbre/info "Error websockets" e))))

(defn tweet->notification
  [{:keys [created_at retweeted_status] :as tweet-notification}]
  (if (contains? tweet-notification :retweeted_status)
    (let [{:keys [id text user retweet_count favorite_count]} retweeted_status]
      {:valid?     true
       :id         id
       :created-at (f/parse twitter-date-formatted created_at)
       :text       text
       :source     {:id    (:id user)
                    :name  (:name user)
                    :image (:profile_image_url user)}
       :count      retweet_count
       :engagement (+ retweet_count favorite_count)})
    {:valid? false}))

(defn- parse-tweet [tweet]
  (try
    (let [result (-> (str tweet)
                     clojure.string/trim-newline
                     parse-string
                     keywordize-keys)]
      (if (map? result)
        result
        {}))
    (catch Exception _
      (timbre/info "[] Reading tweet error")
      {})))

(defn process-tweet [db-conn websockets tweet]
  (let [storage-provider {:read-from-storage      (partial persistence/retrieve-persistence-rows db-conn)
                          :save-to-storage        (partial persistence/upsert-news-report! db-conn)}]

    (persistence/insert-twitter-raw-information! db-conn tweet)

    (let [parsed-tweet (parse-tweet tweet)
          result (domain/process-external-notification storage-provider tweet->notification parsed-tweet)]

      (if-not (nil? result)
        (do
          (disseminate-news-report websockets result)
          (timbre/info "ViewModel->" result))))))

(defrecord TwitterClient [config database websockets]
  component/Lifecycle

  (start [component]
    (let [configuration (:value config)

          credentials (:twitter-api-credentials configuration)

          oauth-credentials (make-oauth-creds (:app-key credentials)
                                              (:app-secret credentials)
                                              (:user-token credentials)
                                              (:user-token-secret credentials))

          process-tweet-fn (fn [_ t]  (process-tweet (:connection database) websockets t))

          ^:dynamic *custom-streaming-callback* (AsyncStreamingCallback. process-tweet-fn
                                                                         (comp println response-return-everything)
                                                                         exception-print)

          media-to-follow (map :id (:media-to-follow (:value config)))

          filter (statuses-filter :params {:follow (clojure.string/join  ", " media-to-follow)}
                                  :oauth-creds oauth-credentials
                                  :callbacks *custom-streaming-callback*)]

      (assoc component :streamed-response *custom-streaming-callback*)
      (assoc component :filter filter)))

  (stop [component]
    (timbre/info "Stopping manager component")
    (timbre/info (:streamed-response component))
    ((:cancel (meta (:streamed-response component))))))