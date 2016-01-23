# TweetStreamProcessor
# Process a stream of tweets invoking the appropriate handler for them
# Improve:
# The dependency of the handlers is now hidden. The test for this file is
# more integration than unit. Research for pattern for the factory of handlers.
class TweetStreamProcessor
  def initialize(
    factory = TweetPersistingOperationFactory.new,
    severity_levels_for_source = SeverityLevelsForSourceRetriever.new)
    @factory = factory
    @severity_levels_for_source = severity_levels_for_source
  end

  def process(tweets)
    tweets.each do |api_tweet|
      tweet = Tweet.find_by_id(api_tweet.id)
      operation = @factory.get_operation(api_tweet, tweet)
      operation.execute
      compute_severity_for_source(tweet)
    end
  end

  def compute_severity_for_source(tweet)
    return if tweet.nil?
    return unless @severity_levels_for_source.can_be_computed(tweet.user_id)

    levels = @severity_levels_for_source.get(tweet.t, tweet.user_id)
    tweet.patch_severity_on_last_version levels
    tweet.save
  end
end
