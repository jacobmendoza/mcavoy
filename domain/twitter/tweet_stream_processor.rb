# TweetStreamProcessor
# Process a stream of tweets invoking the appropriate handler for them
# Improve:
# The dependency of the handlers is now hidden. The test for this file is
# more integration than unit. Research for pattern for the factory of handlers.
class TweetStreamProcessor
  def initialize(factory = TweetPersistingOperationFactory.new)
    @factory = factory
  end

  def process(tweets)
    tweets.each do |tweet|
      existing_document = Tweet.find_by_id(tweet.id)
      operation = @factory.get_operation(tweet, existing_document)
      operation.execute
      # Get percentiles for source
    end
  end
end
