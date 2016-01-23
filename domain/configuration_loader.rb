require 'yaml'

MINIMUM_RECORDS_TO_ALLOW_PERCENTILES = 25
SYSTEM_POLL_INTERVAL = 60
YELLOW = 0.75
ORANGE = 0.85
RED = 0.95

# ConfigurationLoader
# Loads the configuration from a YAML file.
# Improve:
# Now is reading the file every time. Should be cached (somehow).
class ConfigurationLoader
  attr_accessor :database_uri, :consumer_key, :consumer_secret,
                :access_token, :access_token_secret, :list_id

  def initialize(config = 'development')
    fail 'non valid config' unless %w(development test prod).include? config
    @config = config
    load_file_contents
  end

  private

  def load_file_contents
    config = YAML.load_file(File.join(__dir__, '../config.yml'))
    assing_configurations(config)
  end

  private

  def assing_configurations(config)
    @database_uri = config[@config]['uri']
    @consumer_key = config[@config]['consumer_key']
    @consumer_secret = config[@config]['consumer_secret']
    @access_token = config[@config]['access_token']
    @access_token_secret = config[@config]['access_token_secret']
    @list_id = config[@config]['list_id']
  end
end
