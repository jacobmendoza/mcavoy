require 'mongo_mapper'
require 'rufus-scheduler'

def bootstrap
  base_dir = File.expand_path('..', Dir.pwd)
  Dir["#{base_dir}/domain/*.rb"].each { |file| require file }
  Dir["#{base_dir}/domain/twitter/*.rb"].each { |file| require file }
  Dir["#{base_dir}/domain/models/*.rb"].each { |file| require file }
  Dir["#{base_dir}/domain/handlers/*.rb"].each { |file| require file }
  Dir["#{base_dir}/domain/services/*.rb"].each { |file| require file }
  Dir["#{base_dir}/domain/operations/*.rb"].each { |file| require file }

  database_uri = ConfigurationLoader.new.database_uri

  puts "Using #{database_uri}"

  MongoMapper.setup(
    {
      'production' => { 'uri' =>  database_uri }
    }, 'production')
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
