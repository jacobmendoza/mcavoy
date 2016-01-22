# Represents a severity label in the tweet.
class TweetSeverityLabel
  include MongoMapper::EmbeddedDocument

  key :created_at, Time
  key :label, String
end
