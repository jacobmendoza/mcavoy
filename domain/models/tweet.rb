# Class representing a tweet
class Tweet
  include MongoMapper::Document

  many :tweet_updates

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

  def delta_rt
    if tweet_updates.length > 1
      sorted_tweets = tweet_updates.reverse
      last = sorted_tweets[0]
      prev = sorted_tweets[1]
      prev_rt_count = prev.retweet_count == 0 ? 1 : prev.retweet_count
      (((last.retweet_count.to_f / prev_rt_count) - 1) * 100).round(2)
    else
      0
    end
  end

  def patch_severity_on_last_version(severity_levels)
    retweet_count = last_version.retweet_count

    if retweet_count >= severity_levels[YELLOW] && retweet_count < severity_levels[ORANGE]
      last_version.severity_label = 'YELLOW'
      return
    end

    if retweet_count >= severity_levels[ORANGE] && retweet_count < severity_levels[RED]
      last_version.severity_label = 'ORANGE'
      return
    end

    if retweet_count >= severity_levels[RED]
      last_version.severity_label = 'RED'
      return
    end

    last_version.severity_label = 'DEFAULT'
  end
end
