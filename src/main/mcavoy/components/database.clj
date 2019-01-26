(ns mcavoy.components.database
  (:require [com.stuartsierra.component :as component]
            [jdbc.pool.c3p0 :as pool]
            [clojure.java.jdbc :as jdbc]
            [taoensso.timbre :as timbre]
            [clojure.walk :as walk]
            [clojure.string :as str]))

(def local-dev-db-settings
  {:classname   "com.mysql.jdbc.Driver"
   :subprotocol "mysql"
   :subname     "//localhost:3306/mcavoy?zeroDateTimeBehavior=convertToNull&useSSL=false"
   :user        "root"
   :password    ""})

(defn get-database-connection
  ([] (get-database-connection local-dev-db-settings))
  ([db-settings] (pool/make-datasource-spec db-settings)))

(defrecord DatabaseManager [config]
  component/Lifecycle

  (start [component]
    (timbre/info "Starting manager component")
    (let [db-settings (:database (:value config))]
      (assoc component :connection (get-database-connection db-settings))))

  (stop [_]
    (timbre/info "Stopping manager component")))

