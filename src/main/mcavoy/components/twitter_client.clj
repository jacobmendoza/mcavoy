(ns mcavoy.components.twitter-client
  (:use [twitter.oauth]
        [twitter.callbacks]
        [twitter.callbacks.handlers]
        [twitter.api.streaming])
  (:require [taoensso.timbre :as timbre]
            [jdbc.pool.c3p0]
            [com.stuartsierra.component :as component]
            [clojure.data.json :as json]
            [http.async.client]
            [taoensso.timbre :as timbre]
            [mcavoy.api.persistence :as persistence]
            [clojure.walk :refer [keywordize-keys]])
  (:import [twitter.callbacks.protocols AsyncStreamingCallback]))

(defn- process-tweet [database tweet]
  (try
    (let [json (keywordize-keys (json/read-str (clojure.string/trim-newline (str tweet))))]
      (if (contains? json :retweeted_status)
        (persistence/insert-tweet (:connection database) (:retweeted_status json))))
    (catch Exception e
      (timbre/error "ERROR " e))))

(defrecord TwitterClient [database]
  component/Lifecycle

  (start [component]
    (let [credentials (make-oauth-creds)

          ^:dynamic *custom-streaming-callback* (AsyncStreamingCallback. #(process-tweet database %2)
                                                                         (comp println response-return-everything)
                                                                         exception-print)
          filter (statuses-filter :params {:follow "7996082"}
                                  :oauth-creds credentials
                                  :callbacks *custom-streaming-callback*)]
      (assoc component :filter filter)))

  (stop [_]
    (timbre/info "Stopping manager component")))