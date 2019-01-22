(ns mcavoy.websockets
  (:require [com.stuartsierra.component :as component]
            [fulcro.websockets.protocols :as wp :refer [WSListener
                                                        WSNet
                                                        add-listener
                                                        remove-listener
                                                        client-added
                                                        client-dropped]]))

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