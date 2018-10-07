(ns mcavoy.components.database
  (:require [com.stuartsierra.component :as component]
            [jdbc.pool.c3p0 :as pool]
            [clojure.java.jdbc :as jdbc]
            [taoensso.timbre :as timbre]
            [clojure.walk :as walk]
            [clojure.string :as str]))

(defrecord DatabaseManager []
  component/Lifecycle

  (start [component]
    (timbre/info "Starting manager component")
    (assoc component :connection (pool/make-datasource-spec
                                   {:classname   "com.mysql.jdbc.Driver"
                                    :subprotocol "mysql"
                                    :subname     "//localhost:3306/mcavoy?zeroDateTimeBehavior=convertToNull&useSSL=false"
                                    :user        "root"
                                    :password    ""})))

  (stop [_]
    (timbre/info "Stopping manager component")))