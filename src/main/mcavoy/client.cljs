(ns mcavoy.client
  (:require [fulcro.client :as fc]
            [fulcro.i18n :as i18n]
            [fulcro.websockets :as fw]
            [taoensso.timbre :as timbre]
            [fulcro.client.primitives :as prim]
            [mcavoy.api.mutations :as mutations]))

(defn message-format [{:keys [::i18n/localized-format-string ::i18n/locale ::i18n/format-options]}]
  (let [locale-str (name locale)
        ; comes from js file included in HTML. Use shadow-cljs instead of figwheel to make this cleaner
        formatter  (js/IntlMessageFormat. localized-format-string locale-str)]
    (.format formatter (clj->js format-options))))

(declare app)

(defn push-handler [msg]
  (when-let [reconciler (some-> app deref :reconciler)]
    (prim/transact! reconciler `[(mutations/process-message ~msg)])))

(defn state-callback [param param2]
  (when-let [reconciler (some-> app deref :reconciler)]
    (prim/transact! reconciler `[(mutations/initialize-db)])
    (println "Connection status changed" param param2)))

(defonce app (atom (fc/new-fulcro-client
                     :reconciler-options {:shared    {::i18n/message-formatter message-format}
                                          :render-mode :keyframe ; Good for beginners. Remove to optimize UI refresh
                                          :shared-fn ::i18n/current-locale}
                     :networking {:remote (fw/make-websocket-networking
                                           {:websockets-uri "/chsk"
                                            :push-handler push-handler
                                            :state-callback state-callback
                                            :global-error-callback (fn [& args] (apply println "Network error " args))})})))

