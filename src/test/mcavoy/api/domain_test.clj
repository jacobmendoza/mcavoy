(ns mcavoy.api.domain-test
  (:require [clojure.test :refer :all])
  (:require [mcavoy.api.domain :refer [process-external-notification]]
            [mcavoy.components.twitter-client :as twitter]
            [clj-time.core :as t]
            [mcavoy.api.tweet-factory-test :as factory]))

(def adapter twitter/tweet->notification)

(deftest non-valid-notification-does-not-cause-error
  (let [read (fn [id] {:exists? false})
        write (fn [nr] nr)
        write-raw (fn [n] {})
        result (process-external-notification
                 {:read-from-storage   read
                  :save-to-storage     write
                  :save-raw-to-storage write-raw}
                 adapter
                 {})]
    (is (nil? result))))

(deftest new-news-report-from-notification-can-be-processed
  (let [read (fn [id] {:exists? false})
        write (fn [nr] nr)
        write-raw (fn [n] {})
        {:keys [id created-at text user-id user-name relevance]}
        (process-external-notification
          {:read-from-storage   read
           :save-to-storage     write
           :save-raw-to-storage write-raw}
          adapter
          factory/tweet)]

    (is (= 1085650425796190200 id))
    (is (= (t/date-time 2019 1 16 22 49 39 0) created-at))
    (is (= "Example text" text))
    (is (= 807095 user-id) )
    (is (= "The New York Times" user-name))
    (is (= 109 (:count relevance)))
    (is (= 0 (:delta relevance)))
    (is (= 314 (:engagement relevance)))
    (is (= "green" (:label relevance)))))

(deftest update-news-report-from-notification-can-be-processed
  (let [persistence-rows {:exists?      true,
                          :base-row     {:id         1085670443288162300,
                                         :created-at (t/date-time 2018 5 25 20 0 0 0)
                                         :text       "Text from storage",
                                         :user-id    123
                                         :user-name  "Source"},
                          :version-rows [{:id              1,
                                          :news-report-id  1085670443288162300,
                                          :relevance-count 1,
                                          :severity-label  "green",
                                          :created-at      (t/date-time 2018 5 25 20 0 0 0)}]}
        read (fn [_] persistence-rows)
        write (fn [nr] nr)
        write-raw (fn [n] {})
        {:keys [id created-at text user-id user-name relevance]}
        (process-external-notification
          {:read-from-storage   read
           :save-to-storage     write
           :save-raw-to-storage write-raw}
          adapter
          (factory/build-tweet {:created_at "Fri May 25 20:03:00 +0000 2018"
                                :retweeted_status (merge (:retweeted_status factory/tweet) {:retweet_count 181})}))]

    (is (= 1085670443288162300 id))
    (is (= (t/date-time 2018 5 25 20 0 0 0) created-at))
    (is (= "Text from storage" text))
    (is (= 123 user-id) )
    (is (= "Source" user-name))
    (is (= 181 (:count relevance)))
    (is (= 1.0 (:delta relevance)))
    (is (= 386 (:engagement relevance)))))