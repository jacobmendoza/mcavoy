(ns mcavoy.api.mutations
  (:require
    [fulcro.client.mutations :refer [defmutation]]
    [fulcro.client.logging :as log]
    [taoensso.timbre :as timbre]))

(defn- sort-by-delta [state]
  (let [sorted-set (->> (vals (get-in @state [:messages/by-id] []))
                        (sort-by (fn [e] (:delta (:relevance e))))
                        reverse)]
    (swap! state assoc-in [:list/by-name "main" :messages] (mapv (fn [m] [:messages/by-id (:id m)]) sorted-set))))

(defn- insert-news-report [state msg]
  (swap! state assoc-in [:messages/by-id (:id msg)] msg)
  (sort-by-delta state))

(defn- update-news-report [state msg]
  (swap! state update-in [:messages/by-id (:id msg)] assoc :relevance (:relevance msg))
  (sort-by-delta state))

(defmutation initialize-db [params]
  (action [{:keys [state]}]
          (swap! state assoc :list/by-name {"main" {:name "main" :messages []}})
          (swap! state assoc :selected-list [:list/by-name "main"])))

(defmutation process-message [{:keys [msg] :as params}]
  (action [{:keys [state]}]
          (let [current-list (or (get-in @state [:list/by-name "main" :messages]) [])
                already-present? (not (nil? (get-in @state [:messages/by-id (:id msg)])))]

            (if already-present?
              (update-news-report state msg)
              (insert-news-report state msg)))))