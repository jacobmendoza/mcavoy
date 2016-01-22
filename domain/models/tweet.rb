# Class representing a tweet
class Tweet
  include MongoMapper::Document

  many :tweet_updates
  many :tweet_severity_labels

  key :twitter_id, Integer
  key :created_at, Time
  key :text, String
  key :user_id, Integer
  key :user_name, String

  def last_version
    tweet_updates.reverse.first
  end

  def t
    ((last_version.created_at - created_at) / SYSTEM_POLL_INTERVAL).round
  end

  def update_severity_label(percentiles)
    tweet_severity_labels << get_label('DEFAULT')
  end

  private

  def get_label(name)
    TweetSeverityLabel.new(created_at: Time.now, label: name)
  end
end
