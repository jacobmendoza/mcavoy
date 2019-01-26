(ns mcavoy.api.domain
  (:require [mcavoy.api.util :as u]
            [clj-time.core :as t]
            [taoensso.timbre :as timbre]))

(defn build-news-report-from-notification
  [{:keys [id created-at text source count engagement]}]
  {:id            id
   :created-at    created-at
   :updated-at    created-at
   :source        {:id    (:id source)
                   :name  (:name source)
                   :image (:image source)}
   :text          text
   :is-persisted? false
   :versions      [{:count      count
                    :engagement engagement
                    :reach      (:reach source)
                    :label      "green"
                    :created-at created-at}]})

(defn build-news-report-from-persistence
  [{:keys [base-row source-row version-rows]}]
  (let [last-version (first version-rows)]
    {:id            (:id base-row)
     :created-at    (:created-at base-row)
     :updated-at    (:created-at last-version)
     :text          (:text base-row)
     :source        {:id    (:user-id source-row)
                     :name  (:name source-row)
                     :image (:image source-row)}
     :is-persisted? true
     :versions      (map (fn [v]
                           {:count      (:relevance-count v)
                            :engagement (:relevance-count v)
                            :reach      (:source-reach v)
                            :label      (:label v)
                            :created-at (:created-at v)})
                         version-rows)}))

(defn update-relevance
  [{:keys [is-persisted? versions] :as news-report} {:keys [created-at count source engagement]}]
  (if-not is-persisted?
    news-report
    (let [new-update {:count count
                      :engagement engagement
                      :reach (:reach source)
                      :label "green"
                      :created-at created-at}]
      (assoc news-report :versions (conj versions new-update)))))

(defn build-view-model
  [{:keys [created-at updated-at versions] :as news-report}]

  (let [previous-version (second versions)
        last-version (first versions)
        seconds (if (nil? previous-version)
                  0
                  (t/in-seconds (t/interval (:created-at previous-version)
                                            (:created-at last-version))))]

    (-> news-report
        (merge {:created-at (str created-at)
                :updated-at (str updated-at)
                :relevance  {:count       (:count last-version)
                             :count-ratio (float (/
                                                   (:count last-version)
                                                   (:reach last-version)))
                             :delta       (if (nil? previous-version)
                                            0
                                            (float (/
                                                     (- (:count last-version) (:count previous-version))
                                                     (or seconds 1))))

                             :engagement  (:engagement last-version)
                             :label       "green"}})
        (dissoc :versions))))


(defn process-external-notification
  [{:keys [read-from-storage save-to-storage]}
   notification-adapter
   external-notification]

  (u/assert-present external-notification "External notification not provided")
  (u/assert-present read-from-storage "Read from storage function not provided")
  (u/assert-present save-to-storage "Write to storage function not provided")
  (u/assert-present notification-adapter "Adapter function not provided")

  (try
    (let [{:keys [valid? id] :as notification} (notification-adapter external-notification)]
      (if valid?
        (let [{:keys [exists?] :as storage-rows} (read-from-storage id)]
          (if exists?
            (timbre/info "[" id "]" "Updating news report")
            (timbre/info "[" id "]" "Inserting news report"))

          (if-not (empty? notification)
            (-> (if exists?
                  (build-news-report-from-persistence storage-rows)
                  (build-news-report-from-notification notification))
                (update-relevance notification)
                (save-to-storage)
                (build-view-model))))))
    (catch Exception e
      (timbre/info "General error handler for processing" e))))