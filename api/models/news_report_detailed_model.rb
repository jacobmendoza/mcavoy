# Represents a detailed model of a news report that will be returned from the API
class NewsReportDetailedModel < NewsReportSummaryModel
  attr_accessor :source, :tweet_updates

  def initialize(tweet, source)
    super(tweet)
    @source = source
    @tweet_updates = tweet.tweet_updates
  end
end
