(ns mcavoy.api.util
  (:require [clojure.walk :as walk]
            [clojure.string :as str]
            [clj-time.format :as format]))

(defn decode-key
  "Converts a train case string into a snake case keyword."
  [s]
  (keyword (str/replace (name s) "_" "-")))

(defn encode-key
  "Converts a snake case keyword into a train case string."
  [k]
  (str/replace (name k) "-" "_"))

(defn transform-keys
  "Recursively transforms all map keys in coll with the transform-key fn."
  [transform-key coll]
  (letfn [(transform [x] (if (map? x)
                           (into {} (map (fn [[k v]] [(transform-key k) v]) x))
                           x))]
    (walk/postwalk transform coll)))

(defn format-date [date]
  (.toDate (format/parse (format/formatter "E MMM dd HH:mm:ss Z YYYY") date)))

(defn assert-present [fn msg]
  (if (nil? fn)
    (throw (Exception. msg))))

(defn assert-identifier [id msg]
  (if-not (number? id)
    (throw (Exception. msg))))