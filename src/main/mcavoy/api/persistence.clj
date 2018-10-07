(ns mcavoy.api.persistence
  (:require [clojure.string :as str]
            [clojure.walk :as walk]
            [clojure.java.jdbc :as jdbc]
            [taoensso.timbre :as timbre]
            [clj-time.format :as format]))

(defn- decode-key
  "Converts a train case string into a snake case keyword."
  [s]
  (keyword (str/replace (name s) "_" "-")))

(defn- encode-key
  "Converts a snake case keyword into a train case string."
  [k]
  (str/replace (name k) "-" "_"))

(defn- transform-keys
  "Recursively transforms all map keys in coll with the transform-key fn."
  [transform-key coll]
  (letfn [(transform [x] (if (map? x)
                           (into {} (map (fn [[k v]] [(transform-key k) v]) x))
                           x))]
    (walk/postwalk transform coll)))

(defn- format-date [date]
  (.toDate (format/parse (format/formatter "E MMM dd HH:mm:ss Z YYYY") date)))

(defn insert-tweet [connection {:keys [id id_str created_at text user] :as input}]
  (let [user_id (:id user)
        user_id_str (:id_str user)
        user_name (:name user)
        to-db {:id          id
               :id_str      id_str
               :created_at  (format-date created_at)
               :text        text
               :user_id     user_id
               :user_id_str user_id_str
               :user_name   user_name}]
    (timbre/info "To the database" to-db)
    (jdbc/insert! connection :tweets_copy to-db)))