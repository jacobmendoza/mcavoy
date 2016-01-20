RSpec.describe RtsOverTimeFunctionsBuilder do
  describe 'when creating the builder' do
    it 'can be created' do
      expect(RtsOverTimeFunctionsBuilder.new).to_not be_nil
    end
  end

  describe 'when building the function' do
    let(:builder) { RtsOverTimeFunctionsBuilder.new }
    it 'correctly returns the results' do
      first_tweet =
        ApiTweetBuilder
        .new
        .with_created_at(Time.utc(2015, 3, 22, 12, 00, 00))
        .with_update(
          ApiTweetUpdateBuilder
          .new
          .with_created_at(Time.utc(2015, 3, 22, 12, 01, 03))
          .with_retweet_count(10)
        )
        .with_update(
          ApiTweetUpdateBuilder
          .new
          .with_created_at(Time.utc(2015, 3, 22, 12, 02, 05))
          .with_retweet_count(20)
        )

      second_tweet =
        ApiTweetBuilder
        .new
        .with_created_at(Time.utc(2015, 3, 22, 12, 00, 00))
        .with_update(
          ApiTweetUpdateBuilder
          .new
          .with_created_at(Time.utc(2015, 3, 22, 12, 06, 03))
          .with_retweet_count(30)
        )
        .with_update(
          ApiTweetUpdateBuilder
          .new
          .with_created_at(Time.utc(2015, 3, 22, 12, 8, 05))
          .with_retweet_count(80)
        )

      result = builder.build_function([first_tweet, second_tweet])

      first_tweet_fn = result[0]

      expect(first_tweet_fn[1]).to eq 10
      expect(first_tweet_fn[2]).to eq 20

      second_tweet_fn = result[1]

      expect(second_tweet_fn[6]).to eq 30
      expect(second_tweet_fn[8]).to eq 80
    end
  end
end
