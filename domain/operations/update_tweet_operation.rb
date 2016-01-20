# UpdateTweetCommandHandler
# Updates a tweet in the persistent storage with the new values favorite_count
# retweets and favorites.
class UpdateTweetOperation
  def initialize(tweet, existing_document)
    fail 'no tweet has been specified' if tweet.nil?
    fail 'no existing document specified' if existing_document.nil?

    @tweet = tweet
    @existing_document = existing_document
  end

  def execute
    new_update = TweetUpdate.new(
      created_at: Time.new,
      retweet_count: @tweet.retweet_count,
      favorite_count: @tweet.favorite_count)

    @existing_document.tweet_updates << new_update

    @existing_document.save
  end
end
