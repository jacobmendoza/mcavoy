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
    tweets.each do |tweet|
      existing_document = Tweet.find_by_id(tweet.id)
      operation = @factory.get_operation(tweet, existing_document)
      operation.execute
      compute_severity_for_source(existing_document)
    end
  end

  def should_compute_severity_for_source(user_id)
    @severity_levels_for_source.can_be_computed(user_id)
  end

  def compute_severity_for_source(existing_document)
    return if existing_document.nil?
    return unless should_compute_severity_for_source(existing_document.user_id)
    levels = @severity_levels_for_source.get(
      existing_document.t, existing_document.user_id)
    existing_document.update_severity_label levels
    existing_document.save
  end
end
