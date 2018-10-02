(ns mcavoy.ui.root
  (:require
    [fulcro.client.mutations :as m]
    [fulcro.client.data-fetch :as df]
    #?(:cljs [fulcro.client.dom :as dom] :clj [fulcro.client.dom-server :as dom])
    [mcavoy.api.mutations :as api]
    [fulcro.client.primitives :as prim :refer [defsc]]
    [fulcro.i18n :as i18n :refer [tr trf]]
    [mcavoy.ui.components :refer [ui-placeholder]]))

;; The main UI of your application

(defsc Root [this props]
  (dom/div
    (dom/h1 "Test")
    (ui-placeholder)))
