(ns mcavoy.ui.components
  (:require
    [fulcro.client.primitives :as prim :refer [defsc]]
    #?(:cljs [fulcro.client.dom :as dom] :clj [fulcro.client.dom-server :as dom])))

(defsc ServerMessage [this {:keys [db/id message]}]
  {:query [:db/id :message]
   :ident [:messages/by-id :db/id]}
  (dom/div "Message: " id " - " (str message)))

(def ui-server-message (prim/factory ServerMessage {:keyfn :db/id}))

(defsc ServerMessagesList [this {:keys [name messages] :as props}]
  {:query [:name {:messages (prim/get-query ServerMessage)}]
   :ident [:list/by-name :name]}
  (dom/div
    (dom/h1 name)
    (mapv #(ui-server-message {:db/id (:db/id %) :message (:message %)}) messages)))

(def ui-server-messages-list (prim/factory ServerMessagesList))