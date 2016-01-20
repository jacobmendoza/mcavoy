RSpec.describe InsertTweetOperation do
  describe 'when processing a new tweet' do
    let(:tweet_from_api) do
      ApiTweetBuilder.new
        .with_id(123_456)
        .with_text('text')
        .with_created_at(Time.utc(2015, 3, 22))
        .with_user_id(999)
        .with_user_name('username')
        .with_favorite_count(1)
        .with_retweet_count(2)
    end

    let(:handler) { InsertTweetOperation.new(tweet_from_api) }
    let(:tweet) { Tweet.find_by_id(123_456) }

    before do
      handler.execute
    end

    it 'inserts a new tweet in the database' do
      expect(tweet).to_not be_nil
    end

    it 'maps the fields correctly for the tweet' do
      expect(tweet.id).to eq 123_456
      expect(tweet.created_at).to_not be_nil
      expect(tweet.source_created_at).to eq Time.utc(2015, 3, 22)
      expect(tweet.text).to eq 'text'
      expect(tweet.user_id).to eq 999
      expect(tweet.user_name).to eq 'username'
    end

    it 'contains an update' do
      expect(tweet.tweet_updates.count).to eq 1
    end

    it 'maps the fields correctly for the update' do
      expect(tweet.tweet_updates.first.favorite_count).to eq 1
      expect(tweet.tweet_updates.first.retweet_count).to eq 2
    end
  end
end
