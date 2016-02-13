require 'sinatra'
require 'sinatra/json'
require_relative '../domain/application_bootstrapper'
require_relative './models/tweet_api_model'

set :port, 9494
set :protection, except: :http_origin

configure do
  base_dir = "#{File.expand_path('..', Dir.pwd)}/domain"
  app = ApplicationBootstrapper.new(base_dir, 'development')
  app.setup_database
end

before do
  content_type :json
  headers 'Access-Control-Allow-Origin' => '*',
          'Access-Control-Allow-Methods' => %w(OPTIONS GET POST),
          'Access-Control-Allow-Headers' => 'X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept'

  # Fixing AngularJS way of sending the parameters
  next unless request.post?
  params.merge! JSON.parse(request.env['rack.input'].read)
end

get '/latest' do
  tweets = Tweet.sort(:created_at.desc).limit(150)
  models = tweets.map { |t| TweetApiModel.new(t) }
  json models
end

get '/news_report/:id' do |id|
  halt 400, 'the id provided must be a number' unless id =~ /\d+/
  tweet = Tweet.find_by_id(id.to_i)
  halt 404, "cannot find news report with id #{id}" if tweet.nil?
  json tweet
end

get '/source/:source_id' do |source_id|
  halt 400, 'the source_id provided must be a number' unless source_id =~ /\d+/
  id = source_id.to_i
  source = Source.find_by_id(id)
  tweets = Tweet.find_all_by_user_id(id)
  latest_versions_rts = tweets.map { |t| t.last_version.retweet_count }
  retweets_sum = latest_versions_rts.reduce(:+)

  result = {
    name: source.name,
    screen_name: source.screen_name,
    location: source.location,
    description: source.description,
    profile_background_image_url: source.profile_background_image_url,
    profile_image_url: source.profile_image_url,
    count: tweets.count,
    average_retweets: (retweets_sum / tweets.count.to_f).round(2)
  }

  json result
end
