RSpec.describe UpdateTweetCommandHandler do
  describe 'when creating the handler' do
    it 'fails if no tweet has been provided' do
      expect {
        UpdateTweetCommandHandler.new(nil, {})
      }.to raise_error('no tweet has been specified')
    end

    it 'fails if no document has been provided' do
      expect {
        UpdateTweetCommandHandler.new({}, nil)
      }.to raise_error('no existing document specified')
    end
  end

  describe 'when executing the handler' do
    let(:tweet_from_api) {
      TweetBuilder
        .new
        .with_id(123_456)
        .with_favorite_count(1)
        .with_retweet_count(2)
    }

    let(:stored_tweet) {
      tweet = Tweet.new
      tweet.tweet_updates = [
        TweetUpdate.new(
          created_at: Time.new,
          retweet_count: 150,
          favorite_count: 300)
      ]
      tweet
    }

    let(:handler) { UpdateTweetCommandHandler.new(tweet_from_api, stored_tweet) }

    before do
      handler.execute
    end

    it 'inserts a new version' do
      expect(stored_tweet.tweet_updates.count).to eq 2
    end

    it 'maps correctly the new values for the update' do
      expect(stored_tweet.tweet_updates.first.retweet_count).to eq 150
      expect(stored_tweet.tweet_updates.first.favorite_count).to eq 300
    end
  end
end
