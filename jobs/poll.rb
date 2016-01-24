require 'mongo_mapper'
require 'rufus-scheduler'
require_relative '../domain/application_bootstrapper'

def bootstrap
  base_dir = "#{File.expand_path('..', Dir.pwd)}/domain"
  app = ApplicationBootstrapper.new(base_dir, 'development')
  app.setup_database
end

def sync_timeline
  downloader = TwitterListTimeLineDownloader.new
  processor = TweetStreamProcessor.new
  tweets = downloader.download_timeline
  processor.process tweets
end

def execute_scheduler
  scheduler = Rufus::Scheduler.new

  scheduler.every '1m' do
    puts "#{Time.now}Executing poll"
    tweets = sync_timeline
    tweets.each_with_index do |tweet, index|
      puts "#{index} - #{tweet.id} - #{tweet.created_at} (#{tweet.retweet_count}/#{tweet.favorite_count})"
      puts "#{tweet.text}"
      puts '------------'
    end
  end

  scheduler.join
end

bootstrap
execute_scheduler
