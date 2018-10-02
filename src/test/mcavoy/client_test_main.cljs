(ns mcavoy.client-test-main
  (:require mcavoy.tests-to-run
            [fulcro-spec.selectors :as sel]
            [fulcro-spec.suite :as suite]))

(enable-console-print!)

(suite/def-test-suite client-tests {:ns-regex #"mcavoy..*-spec"}
  {:default   #{::sel/none :focused}
   :available #{:focused}})

