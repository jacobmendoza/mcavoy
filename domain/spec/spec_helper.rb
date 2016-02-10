require 'mongo_mapper'
require 'twitter'
require_relative '../application_bootstrapper'

RSpec.configure do |config|
  # Load data builders
  require 'builders/api_tweet_builder.rb'
  require 'builders/api_tweet_user_builder.rb'

  # Load application
  base_dir = File.expand_path('.', Dir.pwd)
  app = ApplicationBootstrapper.new(base_dir, 'test')

  config.before(:suite) do
    app.setup_database
  end

  config.after(:each) do
    Tweet.destroy_all
    Source.destroy_all
  end

  config.after(:suite) do
    app.drop_database
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
