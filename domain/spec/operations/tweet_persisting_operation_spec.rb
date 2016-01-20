RSpec.describe TweetPersistingOperationFactory do
  let(:factory) { TweetPersistingOperationFactory.new }

  describe 'When no previous document exists' do
    it 'returns an insert operation' do
      tweet = ApiTweetBuilder.new.with_id(123)
      operation = factory.get_operation(tweet)
      expect(operation).to be_a(InsertTweetOperation)
    end
  end

  describe 'When previous document exists' do
    it 'returns an update operation' do
      existing_document = Tweet.create(id: 123)
      tweet = ApiTweetBuilder.new.with_id(123)
      operation = factory.get_operation(tweet, existing_document)
      expect(operation).to be_a(UpdateTweetOperation)
    end
  end
end
