# InsertTweetCommandHandler
# Stores a tweet coming from the API, mapping the fields.
class InsertTweetCommandHandler
  def initialize(tweet)
    @tweet = tweet
  end

  def execute
    Tweet.create(
      id: @tweet.id,
      created_at: Time.new,
      source_created_at: @tweet.created_at,
      text: @tweet.text,
      user_id: @tweet.user.id,
      user_name: @tweet.user.name,
      tweet_updates: [build_update]
    )
  end

  private

  def build_update
    TweetUpdate.new(
      created_at: Time.new,
      retweet_count: @tweet.retweet_count,
      favorite_count: @tweet.favorite_count)
  end
end
