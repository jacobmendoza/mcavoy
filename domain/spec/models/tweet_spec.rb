require 'json'

RSpec.describe Tweet do
  describe 'When using the model' do
    it 'can be instantiated' do
      expect(Tweet.new).to_not be_nil
    end
  end

  describe 'When inserting labels' do
    it 'patches DEFAULT in the last version if no severity' do
      tweet = Tweet.new(tweet_updates: [TweetUpdate.new(retweet_count: 1)])
      severity_levels = { YELLOW => 200, ORANGE => 300, RED => 400 }

      tweet.patch_severity_on_last_version(severity_levels)

      serialized_levels = JSON.dump severity_levels
      expect(tweet.last_version.severity_label).to eq 'DEFAULT'
      expect(tweet.last_version.severity_levels).to eq serialized_levels.to_s
    end

    it 'patches YELLOW in the last version if YELLOW severity' do
      tweet = Tweet.new(tweet_updates: [TweetUpdate.new(retweet_count: 200)])
      severity_levels = { YELLOW => 200, ORANGE => 300, RED => 400 }

      tweet.patch_severity_on_last_version(severity_levels)

      serialized_levels = JSON.dump severity_levels
      expect(tweet.last_version.severity_label).to eq 'YELLOW'
      expect(tweet.last_version.severity_levels).to eq serialized_levels.to_s
    end

    it 'patches ORANGE in the last version if ORANGE severity' do
      tweet = Tweet.new(tweet_updates: [TweetUpdate.new(retweet_count: 350)])
      severity_levels = { YELLOW => 200, ORANGE => 300, RED => 400 }

      tweet.patch_severity_on_last_version(severity_levels)

      serialized_levels = JSON.dump severity_levels
      expect(tweet.last_version.severity_label).to eq 'ORANGE'
      expect(tweet.last_version.severity_levels).to eq serialized_levels.to_s
    end

    it 'patches RED in the last version if ORANGE severity' do
      tweet = Tweet.new(tweet_updates: [TweetUpdate.new(retweet_count: 450)])
      severity_levels = { YELLOW => 200, ORANGE => 300, RED => 400 }

      tweet.patch_severity_on_last_version(severity_levels)

      serialized_levels = JSON.dump severity_levels
      expect(tweet.last_version.severity_label).to eq 'RED'
      expect(tweet.last_version.severity_levels).to eq serialized_levels.to_s
    end
  end
end
