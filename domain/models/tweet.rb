# Class representing a tweet
class Tweet
  include MongoMapper::Document

  many :tweet_updates

  key :twitter_id, Integer
  key :created_at, Time
  key :text, String
  key :user_id, Integer
  key :user_name, String
end
