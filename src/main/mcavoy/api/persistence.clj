(ns mcavoy.api.persistence
  (:require [clojure.java.jdbc :as jdbc]
            [taoensso.timbre :as timbre]
            [clj-time.core :as t]
            [mcavoy.api.util :as u]
            [clj-time.jdbc]))

(defn create-sources-table
  [connection]
  (let [ddl (jdbc/create-table-ddl :sources [[:id "INT UNSIGNED PRIMARY KEY"]
                                             [:name "TEXT"]
                                             [:image "NVARCHAR(512)"]])]
    (jdbc/db-do-commands connection [ddl])))

(defn retrieve-persistence-rows
  [connection id]

  (u/assert-identifier id (str "News reports must be retrieved by id (not " id ")"))

  (let [base-row (first (jdbc/query connection ["SELECT * FROM news_reports where id = ?" id]))
        exists? (not (nil? base-row))
        source-row (if exists?
                     (first (jdbc/query connection ["SELECT * FROM sources WHERE id = ?" (:source-id base-row)])))]

    (if exists?
      (u/assert-present source-row "Source not existing for an existing news report"))

    (u/transform-keys
      u/decode-key
      {
       :exists?      exists?
       :base-row     base-row
       :source-row   source-row
       :version-rows (jdbc/query connection ["SELECT * FROM news_report_updates where news_report_id = ? ORDER BY id DESC LIMIT 2" id])})))

(defn upsert-source! [connection {:keys [id] :as source}]
  (let [source-exists? (some? (first (jdbc/query connection ["SELECT * FROM sources WHERE id = ?" id])))]
    (if-not source-exists?
      (jdbc/insert! connection :sources source))))

(defn upsert-news-report! [connection {:keys [id created-at text source is-persisted? versions] :as input}]
  (let [last-version (first versions)
        to-db {:id         id
               :created-at created-at
               :text       text
               :source-id  (:id source)}

        update-to-db {:news-report-id  id
                      :created-at (:created-at last-version)
                      :relevance-count (:count last-version)
                      :severity-label  (:label last-version)}]
    (try

      (upsert-source! connection source)

      (if-not is-persisted?
        (jdbc/insert! connection :news_reports (u/transform-keys u/encode-key to-db)))

      (jdbc/insert! connection :news_report_updates (u/transform-keys u/encode-key update-to-db))

      input

      (catch Exception e
        (timbre/info "Error inserting in db" e)))))

(defn insert-twitter-raw-information! [connection info]
  (jdbc/insert! connection :twitter_notifications {:created_at (t/now)
                                                   :text (str info)}))