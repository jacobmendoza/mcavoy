(ns mcavoy.api.tweet-factory-test
  (:require [clojure.test :refer :all]))

(def tweet {:quote_count               0,
            :in_reply_to_screen_name   nil,
            :is_quote_status           false,
            :coordinates               nil,
            :filter_level              "low",
            :in_reply_to_status_id_str nil,
            :place                     nil,
            :timestamp_ms              "1547678979118",
            :geo                       nil,
            :in_reply_to_status_id     nil,
            :entities
                                       {:hashtags [],
                                        :urls     [],
                                        :user_mentions
                                                  [{:screen_name "nytimes",
                                                    :name        "The New York Times",
                                                    :id          807095,
                                                    :id_str      "807095",
                                                    :indices     [3 11]}],
                                        :symbols  []},
            :retweeted_status
                                       {:quote_count               40,
                                        :in_reply_to_screen_name   nil,
                                        :is_quote_status           false,
                                        :coordinates               nil,
                                        :filter_level              "low",
                                        :in_reply_to_status_id_str nil,
                                        :place                     nil,
                                        :possibly_sensitive        false,
                                        :geo                       nil,
                                        :in_reply_to_status_id     nil,
                                        :extended_tweet
                                                                   {:full_text
                                                                                        "Trump's nominee to head the EPA, Andrew Wheeler, said he doesn't believe climate change is one of the \"great crises facing our planet:\" \"I would not call it the greatest crisis, no sir. I would call it a huge issue that has to be addressed globally.\" https://t.co/nhrXLlHwpL",
                                                                    :display_text_range [0 274],
                                                                    :entities
                                                                                        {:hashtags      [],
                                                                                         :urls
                                                                                                        [{:url          "https://t.co/nhrXLlHwpL",
                                                                                                          :expanded_url "https://nyti.ms/2FE0zMh",
                                                                                                          :display_url  "nyti.ms/2FE0zMh",
                                                                                                          :indices      [251 274]}],
                                                                                         :user_mentions [],
                                                                                         :symbols       []}},
                                        :entities
                                                                   {:hashtags      [],
                                                                    :urls
                                                                                   [{:url     "https://t.co/NoOuXsahJo",
                                                                                     :expanded_url
                                                                                              "https://twitter.com/i/web/status/1085650425796190208",
                                                                                     :display_url
                                                                                              "twitter.com/i/web/status/1…",
                                                                                     :indices [117 140]}],
                                                                    :user_mentions [],
                                                                    :symbols       []},
                                        :source
                                                                   "<a href=\"http://www.socialflow.com\" rel=\"nofollow\">SocialFlow</a>",
                                        :lang                      "en",
                                        :in_reply_to_user_id_str   nil,
                                        :id                        1085650425796190200,
                                        :contributors              nil,
                                        :truncated                 true,
                                        :retweeted                 false,
                                        :in_reply_to_user_id       nil,
                                        :id_str                    "1085650425796190208",
                                        :favorited                 false,
                                        :user
                                                                   {:description
                                                                                                  "Where the conversation begins. Follow for breaking news, special reports, RTs of our journalists and more. Visit http://nyti.ms/2FVHq9v to share news tips.",
                                                                    :profile_link_color           "607696",
                                                                    :profile_sidebar_border_color "FFFFFF",
                                                                    :profile_image_url
                                                                                                  "http://pbs.twimg.com/profile_images/942784892882112513/qV4xB0I3_normal.jpg",
                                                                    :profile_use_background_image true,
                                                                    :default_profile              false,
                                                                    :profile_background_image_url
                                                                                                  "http://abs.twimg.com/images/themes/theme14/bg.gif",
                                                                    :is_translator                false,
                                                                    :profile_text_color           "333333",
                                                                    :profile_banner_url
                                                                                                  "https://pbs.twimg.com/profile_banners/807095/1522172276",
                                                                    :name                         "The New York Times",
                                                                    :profile_background_image_url_https
                                                                                                  "https://abs.twimg.com/images/themes/theme14/bg.gif",
                                                                    :favourites_count             17599,
                                                                    :screen_name                  "nytimes",
                                                                    :listed_count                 198719,
                                                                    :profile_image_url_https
                                                                                                  "https://pbs.twimg.com/profile_images/942784892882112513/qV4xB0I3_normal.jpg",
                                                                    :statuses_count               346875,
                                                                    :contributors_enabled         false,
                                                                    :following                    nil,
                                                                    :lang                         "en",
                                                                    :utc_offset                   nil,
                                                                    :notifications                nil,
                                                                    :default_profile_image        false,
                                                                    :profile_background_color     "131516",
                                                                    :id                           807095,
                                                                    :follow_request_sent          nil,
                                                                    :url                          "http://www.nytimes.com/",
                                                                    :translator_type              "none",
                                                                    :time_zone                    nil,
                                                                    :profile_sidebar_fill_color   "EFEFEF",
                                                                    :protected                    false,
                                                                    :profile_background_tile      true,
                                                                    :id_str                       "807095",
                                                                    :geo_enabled                  true,
                                                                    :location                     "New York City",
                                                                    :followers_count              42669989,
                                                                    :friends_count                881,
                                                                    :verified                     true,
                                                                    :created_at
                                                                                                  "Fri Mar 02 20:41:42 +0000 2007"},
                                        :reply_count               112,
                                        :retweet_count             109,
                                        :favorite_count            205,
                                        :created_at                "Wed Jan 16 21:30:06 +0000 2019",
                                        :text
                                                                   "Example text"},
            :source
                                       "<a href=\"http://twitter.com/download/iphone\" rel=\"nofollow\">Twitter for iPhone</a>",
            :lang                      "en",
            :in_reply_to_user_id_str   nil,
            :id                        1085670443288162300,
            :contributors              nil,
            :truncated                 false,
            :retweeted                 false,
            :in_reply_to_user_id       nil,
            :id_str                    "1085670443288162305",
            :favorited                 false,
            :user
                                       {:description                        "OFFICE",
                                        :profile_link_color                 "1DA1F2",
                                        :profile_sidebar_border_color       "C0DEED",
                                        :profile_image_url
                                                                            "http://pbs.twimg.com/profile_images/1044090880133615616/-s-pVB_e_normal.jpg",
                                        :profile_use_background_image       true,
                                        :default_profile                    true,
                                        :profile_background_image_url       "",
                                        :is_translator                      false,
                                        :profile_text_color                 "333333",
                                        :name                               "castseven 853",
                                        :profile_background_image_url_https "",
                                        :favourites_count                   6058,
                                        :screen_name                        "IZSjAHkTc9mU809",
                                        :listed_count                       0,
                                        :profile_image_url_https
                                                                            "https://pbs.twimg.com/profile_images/1044090880133615616/-s-pVB_e_normal.jpg",
                                        :statuses_count                     1454,
                                        :contributors_enabled               false,
                                        :following                          nil,
                                        :lang                               "en",
                                        :utc_offset                         nil,
                                        :notifications                      nil,
                                        :default_profile_image              false,
                                        :profile_background_color           "F5F8FA",
                                        :id                                 1010865833818579000,
                                        :follow_request_sent                nil,
                                        :url                                nil,
                                        :translator_type                    "none",
                                        :time_zone                          nil,
                                        :profile_sidebar_fill_color         "DDEEF6",
                                        :protected                          false,
                                        :profile_background_tile            false,
                                        :id_str                             "1010865833818578944",
                                        :geo_enabled                        false,
                                        :location                           "日本 大阪",
                                        :followers_count                    0,
                                        :friends_count                      5,
                                        :verified                           false,
                                        :created_at
                                                                            "Sun Jun 24 12:42:50 +0000 2018"},
  :reply_count               0,
            :retweet_count             0,
            :favorite_count            0,
            :created_at                "Wed Jan 16 22:49:39 +0000 2019",
            :text
                                       "Example text"})

(defn build-tweet [extra-data]
  (merge tweet extra-data))