# Represents a model of a news report
class NewsReportSummaryModel
  attr_accessor :id, :id_str, :created_at, :source_created_at, :user_id,
                :user_name, :retweet_count, :favorite_count, :severity_label

  def initialize(tweet)
    @id = tweet.id
    @id_str = tweet.id.to_s
    @created_at = tweet.created_at
    @source_created_at = tweet.source_created_at
    @user_id = tweet.user_id
    @user_name = tweet.user_name
    @text = tweet.text
    @delta_rt = tweet.delta_rt
    @elapsed_time = tweet.elapsed_time

    last_version = tweet.last_version

    @retweet_count = last_version.retweet_count
    @favorite_count = last_version.favorite_count
    @severity_label = last_version.severity_label
  end
end
