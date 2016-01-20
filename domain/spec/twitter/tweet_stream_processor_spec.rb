RSpec.describe TweetStreamProcessor do
  describe 'when processing an stream of tweets' do
    let(:processor) { TweetStreamProcessor.new }

    it 'inserts and updates records' do
      # Previous information existing in the db
      Tweet.create(id: 123)

      tweets = [ApiTweetBuilder.new.with_id(123), ApiTweetBuilder.new.with_id(456)]

      processor.process tweets

      expect(Tweet.find_by_id(123)).to_not be_nil
      expect(Tweet.find_by_id(456)).to_not be_nil
    end
  end
end
