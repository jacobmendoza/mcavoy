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
