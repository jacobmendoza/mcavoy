(ns mcavoy.ui.components
  (:require
    [fulcro.client.primitives :as prim :refer [defsc]]
    #?(:cljs [fulcro.client.dom :as dom] :clj [fulcro.client.dom-server :as dom])))

(defsc ServerMessage [this {:keys [id text source relevance]}]
  {:query [:id :text :relevance :source]
   :ident [:messages/by-id :id]}
  (let [{:keys [count count-ratio delta engagement label]} relevance]
    (dom/div
      (dom/div {:id id :class "news-report"}
               (dom/div {:class "source-container"}
                        (dom/div
                          (dom/img {:src (:image source) :style {:paddingRight "8px" :width "12px" :height "12px"}})
                          (dom/span (:name source))
                          (dom/span (str id))
                          (dom/span engagement)
                          (dom/span delta)
                          (dom/span count-ratio)))

               (dom/div {:class "text-container"}
                        (dom/span {:class "relevance-count"} (dom/b count))
                        (dom/span {:class "news-report-text"} text))))))

(def ui-server-message (prim/factory ServerMessage {:keyfn :id}))

(defsc ServerMessagesList [this {:keys [name messages] :as props}]
  {:query [:name {:messages (prim/get-query ServerMessage)}]
   :ident [:list/by-name :name]}
  (dom/div
    (dom/div {:className "menu-bar"}
      (dom/h1 "frenchpress"))
    (mapv #(ui-server-message %) messages)))

(def ui-server-messages-list (prim/factory ServerMessagesList))