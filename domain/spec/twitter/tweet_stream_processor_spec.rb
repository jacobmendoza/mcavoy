RSpec.describe TweetStreamProcessor do
  describe 'when processing an stream of tweets' do
    let(:factory) { double }
    let(:source_updater) { double }
    let(:severity_levels_for_source) { double }
    let(:processor) { TweetStreamProcessor.new(factory, source_updater, severity_levels_for_source) }
    let(:api_tweet1) { ApiTweetBuilder.new.with_id(123) }
    let(:api_tweet2) { ApiTweetBuilder.new.with_id(456) }
    let(:tweets) { [api_tweet1, api_tweet2] }
    let(:operation_double) { double }
    let(:stored_tweet_user_id) { 1234 }
    let(:stored_tweet) {
      Tweet.create(
        id: 123,
        created_at: Time.utc(2015, 3, 22, 12, 02, 05),
        user_id: stored_tweet_user_id,
        tweet_updates: [
          TweetUpdate.new(retweet_count: 10, created_at: Time.utc(2015, 3, 22, 12, 03, 32))
        ])
    }

    before do
      allow(source_updater).to receive(:upsert).with(api_tweet1.user)
      allow(source_updater).to receive(:upsert).with(api_tweet2.user)

      allow(severity_levels_for_source).to receive(:can_be_computed)
        .with(stored_tweet_user_id) { true }

      allow(severity_levels_for_source).to receive(:get)
        .with(1, stored_tweet_user_id) {
          { YELLOW => 100, ORANGE => 200, RED => 300 }
        }

      allow(factory).to receive(:get_operation)
        .with(api_tweet1, stored_tweet) { operation_double }

      allow(factory).to receive(:get_operation)
        .with(api_tweet2, nil) { operation_double }

      allow(operation_double).to receive(:execute)
    end

    it 'inserts and updates records' do
      expect(factory).to receive(:get_operation)
        .with(api_tweet1, stored_tweet) { operation_double }

      expect(factory).to receive(:get_operation)
        .with(api_tweet2, nil) { operation_double }

      expect(operation_double).to receive(:execute).twice

      processor.process tweets
    end

    it 'inserts a new severity label into the tweet' do
      sev_levels = { YELLOW => 100, ORANGE => 200, RED => 300 }

      expect(severity_levels_for_source).to receive(:get)
        .with(1, stored_tweet_user_id) { sev_levels }

      processor.process tweets

      updated_tweet = Tweet.find_by_id(123)

      expect(updated_tweet.last_version.severity_label).to eq 'DEFAULT'
    end

    it 'does not insert a new severity label if it cannot be computed' do
      expect(severity_levels_for_source).to receive(:can_be_computed)
        .with(stored_tweet_user_id) { false }

      expect(severity_levels_for_source).to_not receive(:get)
        .with(1, stored_tweet_user_id)

      processor.process tweets
    end

    it 'inserts or updates the source' do
      expect(source_updater).to receive(:upsert).with(api_tweet1.user)
      expect(source_updater).to receive(:upsert).with(api_tweet2.user)

      processor.process tweets
    end
  end
end
