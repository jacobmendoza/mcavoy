(ns mcavoy.ui.root
  (:require
    [fulcro.client.mutations :as m]
    [fulcro.client.data-fetch :as df]
    #?(:cljs [fulcro.client.dom :as dom] :clj [fulcro.client.dom-server :as dom])
    [mcavoy.api.mutations :as api]
    [fulcro.client.primitives :as prim :refer [defsc]]
    [fulcro.i18n :as i18n :refer [tr trf]]
    [mcavoy.ui.components :as components :refer [ui-server-messages-list]]))

(defsc Root [this {:keys [selected-list] :as props}]
  {:query [{:selected-list (prim/get-query components/ServerMessagesList)}]}
  (dom/div
    (ui-server-messages-list selected-list)))