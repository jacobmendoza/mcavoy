require 'json'
# Class representing a tweet
class Tweet
  include MongoMapper::Document

  many :tweet_updates

  key :id_str, String
  key :twitter_id, Integer
  key :created_at, Time
  key :source_created_at, Time
  key :text, String
  key :user_id, Integer
  key :user_name, String

  def last_version
    tweet_updates.reverse.first
  end

  def elapsed_time(from_version = last_version)
    ((from_version.created_at - created_at) / SYSTEM_POLL_INTERVAL).round
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
      assign_new_severity 'YELLOW', severity_levels
      return
    end

    if retweet_count >= severity_levels[ORANGE] && retweet_count < severity_levels[RED]
      assign_new_severity 'ORANGE', severity_levels
      return
    end

    if retweet_count >= severity_levels[RED]
      assign_new_severity 'RED', severity_levels
      return
    end

    assign_new_severity 'DEFAULT', severity_levels
  end

  private

  def assign_new_severity(label, severity_levels_used)
    last_version.severity_label = label
    last_version.severity_levels = (JSON.dump severity_levels_used).to_s
  end
end
