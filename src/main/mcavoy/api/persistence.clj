(ns mcavoy.api.persistence
  (:require [clojure.java.jdbc :as jdbc]
            [taoensso.timbre :as timbre]
            [clj-time.core :as t]
            [mcavoy.api.util :as u]
            [clj-time.jdbc]))

(defn retrieve-persistence-rows
  [connection id]

  (u/assert-identifier id (str "News reports must be retrieved by id (not " id ")"))

  (let [base-row (first (jdbc/query connection ["SELECT * FROM news_reports where id = ?" id]))]
    (u/transform-keys
      u/decode-key
      {
       :exists?      (not (nil? base-row))
       :base-row     base-row
       :version-rows (jdbc/query connection ["SELECT * FROM news_report_updates where news_report_id = ? ORDER BY id DESC LIMIT 2" id])})))

(defn upsert-news-report! [connection {:keys [id created-at user-id text user-name user-image is-persisted? versions] :as input}]
  (let [last-version (first versions)
        to-db {:id         id
               :created-at created-at
               :text       text
               :user-id    user-id
               :user-name  user-name
               :user-image user-image}

        update-to-db {:news-report-id  id
                      :created-at (:created-at last-version)
                      :relevance-count (:count last-version)
                      :severity-label  (:label last-version)}]
    (try

      (if-not is-persisted?
        (jdbc/insert! connection :news_reports (u/transform-keys u/encode-key to-db)))

      (jdbc/insert! connection :news_report_updates (u/transform-keys u/encode-key update-to-db))

      input

      (catch Exception e
        (timbre/info "Error inserting in db" e)))))

(defn insert-twitter-raw-information! [connection info]
  (jdbc/insert! connection :twitter_notifications {:created_at (t/now)
                                                   :text (str info)}))