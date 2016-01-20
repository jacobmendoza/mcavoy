require 'mongo_mapper'
require 'twitter'
require_relative '../configuration_loader'

RSpec.configure do |config|
  app_config = ConfigurationLoader.new('test')

  # Load data builders
  require 'builders/api_tweet_builder.rb'
  require 'builders/api_tweet_user_builder.rb'
  require 'builders/api_tweet_update_builder.rb'

  # Load application
  base_dir = File.expand_path('.', Dir.pwd)
  Dir["#{base_dir}/*.rb"].each { |file| require file }
  Dir["#{base_dir}/twitter/*.rb"].each { |file| require file }
  Dir["#{base_dir}/models/*.rb"].each { |file| require file }
  Dir["#{base_dir}/handlers/*.rb"].each { |file| require file }
  Dir["#{base_dir}/services/*.rb"].each { |file| require file }
  Dir["#{base_dir}/operations/*.rb"].each { |file| require file }

  config.before(:suite) do
    MongoMapper.setup(
      {
        'production' => { 'uri' => app_config.database_uri }
      }, 'production')
  end

  config.after(:each) do
    Tweet.destroy_all
  end

  config.after(:suite) do
    db = MongoMapper.database
    db.command(dropDatabase: 1)
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
