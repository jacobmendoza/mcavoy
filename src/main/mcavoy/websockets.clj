(ns mcavoy.websockets
  (:require [com.stuartsierra.component :as component]
            [fulcro.websockets.protocols :as wp :refer [WSListener
                                                        WSNet
                                                        add-listener
                                                        remove-listener
                                                        client-added
                                                        client-dropped]])
  (:import (java.util Date)))

(defrecord Broadcaster [websockets ^Thread thread]
  component/Lifecycle
  (start [this]
    (let [t (new Thread (fn []
                          (Thread/sleep 10000)
                          (let [cids (some-> websockets :connected-uids deref :any)]
                            (doseq [cid cids]
                              (wp/push websockets cid :base-message {:db/id (rand-int 30) :message (Date.)})))
                          (recur)))]
      (.start t)
      (assoc this :thread t)))
  (stop [this] (.stop thread)))

(defn make-broadcaster []
  (component/using
    (map->Broadcaster {})
    [:websockets]))

(defrecord ChannelListener [websockets]
  WSListener
  (client-dropped [this ws-net cid]
    (println "Client disconnected " cid))
  (client-added [this ws-net cid]
    (println "Client connected " cid))

  component/Lifecycle
  (start [component]
    (add-listener websockets component)
    component)
  (stop [component]
    (remove-listener websockets component)
    component))

(defn make-channel-listener []
  (component/using
    (map->ChannelListener {})
    [:websockets]))