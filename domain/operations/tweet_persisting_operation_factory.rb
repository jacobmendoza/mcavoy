# Returns the appropriate operation for storing a tweet
class TweetPersistingOperationFactory
  def get_operation(tweet, existing_document = nil)
    if existing_document.nil?
      InsertTweetOperation.new(tweet)
    else
      UpdateTweetOperation.new(tweet, existing_document)
    end
  end
end
