(ns mcavoy.server
  (:require
    [fulcro.easy-server :refer [make-fulcro-server]]
    ; MUST require these, or you won't get them installed.
    [mcavoy.api.read]
    [mcavoy.api.mutations]
    [mcavoy.websockets :refer [make-channel-listener make-broadcaster]]
    [fulcro.server :as server]
    [fulcro.websockets :as fw]))

(defn build-server
  [{:keys [config] :or {config "config/dev.edn"}}]
  (make-fulcro-server
    :parser-injections #{:config}
    :config-path config
    :components {:websockets (fw/make-websockets
                               (server/fulcro-parser) {})
                 :broadcaster      (make-broadcaster)
                 :channel-listener (make-channel-listener)
                 :ws-adapter       (fw/make-easy-server-adapter)}))



