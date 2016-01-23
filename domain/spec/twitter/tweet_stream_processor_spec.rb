RSpec.describe TweetStreamProcessor do
  describe 'when processing an stream of tweets' do
    let(:factory) { double }
    let(:severity_levels_for_source) { double }
    let(:processor) { TweetStreamProcessor.new(factory, severity_levels_for_source) }
    let(:api_tweet1) { ApiTweetBuilder.new.with_id(123) }
    let(:api_tweet2) { ApiTweetBuilder.new.with_id(456) }
    let(:tweets) { [api_tweet1, api_tweet2] }
    let(:operation_double) { double }
    let(:stored_tweet) {
      Tweet.create(
        id: 123,
        created_at: Time.utc(2015, 3, 22, 12, 02, 05),
        user_id: 1234, tweet_updates:
        [
          TweetUpdate.new(retweet_count: 10, created_at: Time.utc(2015, 3, 22, 12, 03, 32))
        ])
    }

    it 'inserts and updates records' do
      allow(severity_levels_for_source).to receive(:can_be_computed).with(1234) { true }
      allow(severity_levels_for_source).to receive(:get).with(1, 1234) {
        { YELLOW => 100, ORANGE => 200, RED => 300 }
      }

      expect(factory).to receive(:get_operation).with(api_tweet1, stored_tweet) { operation_double }
      expect(factory).to receive(:get_operation).with(api_tweet2, nil) { operation_double }
      expect(operation_double).to receive(:execute).twice

      processor.process tweets
    end

    it 'inserts a new severity label into the tweet' do
      allow(factory).to receive(:get_operation).with(api_tweet1, stored_tweet) { operation_double }
      allow(factory).to receive(:get_operation).with(api_tweet2, nil) { operation_double }
      allow(operation_double).to receive(:execute)
      allow(severity_levels_for_source).to receive(:can_be_computed).with(1234) { true }

      expect(severity_levels_for_source).to receive(:get).with(1, 1234) {
        { YELLOW => 100, ORANGE => 200, RED => 300 }
      }

      processor.process tweets

      updated_tweet = Tweet.find_by_id(123)

      expect(updated_tweet.last_version.severity_label).to eq 'DEFAULT'
    end

    it 'does not insert a new severity label into the tweet if it cannot be computed' do
      allow(factory).to receive(:get_operation).with(api_tweet1, stored_tweet) { operation_double }
      allow(factory).to receive(:get_operation).with(api_tweet2, nil) { operation_double }
      allow(operation_double).to receive(:execute)

      expect(severity_levels_for_source).to receive(:can_be_computed).with(1234) { false }
      expect(severity_levels_for_source).to_not receive(:get).with(1, 1234)

      processor.process tweets
    end
  end
end
