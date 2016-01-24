require 'mongo_mapper'
require_relative './configuration_loader'

MINIMUM_RECORDS_TO_ALLOW_PERCENTILES = 25
SYSTEM_POLL_INTERVAL = 60
YELLOW = 0.75
ORANGE = 0.85
RED = 0.95

# Loads the application
class ApplicationBootstrapper
  def initialize(base_path, config)
    @base_path = base_path
    @config_loader = ConfigurationLoader.new(config)

    load_files
  end

  def setup_database
    puts "Using #{@config_loader.database_uri}"
    MongoMapper.setup(
      {
        'production' => { 'uri' =>  @config_loader.database_uri }
      }, 'production')
  end

  def drop_database
    db = MongoMapper.database
    db.command(dropDatabase: 1)
  end

  private

  def load_files
    Dir["#{@base_path}/*.rb"].each { |file| require file }
    %w(twitter models handlers services operations).each do |f|
      Dir["#{@base_path}/#{f}/*.rb"].each { |file| require file }
    end
  end
end
