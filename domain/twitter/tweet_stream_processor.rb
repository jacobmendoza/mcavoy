# TweetStreamProcessor
# Process a stream of tweets invoking the appropriate handler for them
# Improve:
# The dependency of the handlers is now hidden. The test for this file is
# more integration than unit. Research for pattern for the factory of handlers.
class TweetStreamProcessor
  def process(tweets)
    tweets.each do |tweet|
      existing_document = Tweet.find_by_id(tweet.id)
      if existing_document.nil?
        command = InsertTweetCommandHandler.new(tweet)
      else
        command = UpdateTweetCommandHandler.new(tweet, existing_document)
      end
      command.execute
    end
  end
end
