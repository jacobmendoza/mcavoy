(ns mcavoy.api.mutations
  (:require
    [fulcro.client.mutations :refer [defmutation]]
    [fulcro.client.logging :as log]
    [taoensso.timbre :as timbre]))

(defmutation initialize-db [params]
  (action [{:keys [state]}]
          (swap! state assoc :list/by-name {"main" {:name "main" :messages []}})
          (swap! state assoc :selected-list [:list/by-name "main"])))

(defmutation process-message [{:keys [msg] :as params}]
  (action [{:keys [state]}]
          (let [current-list (or (get-in @state [:list/by-name "main" :messages]) [])
                new-info (conj current-list msg)]
            (swap! state assoc-in [:list/by-name "main" :messages] new-info))))