# Represents an update over a tweet
class TweetUpdate
  include MongoMapper::EmbeddedDocument

  key :created_at, Time
  key :retweet_count, Integer
  key :favorite_count, Integer

  key :severity_label, String
  key :severity_levels, String
end
