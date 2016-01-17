require 'twitter'

# TwitterApiWrapper
# Wraps the ruby client https://github.com/sferik/twitter
class TwitterApiWrapper
  def initialize(client = nil, config = ConfigurationLoader.new)
    @client = client
    @config = config
  end

  def client
    fail 'Consumer key is missing in configuration' if @config.consumer_key.nil?
    fail 'Consumer secret is missing in configuration' if @config.consumer_secret.nil?

    return @client unless @client.nil?

    @client = create_client @config.consumer_key, @config.consumer_secret
  end

  private

  def create_client(consumer_key, consumer_secret)
    Twitter::REST::Client.new do |config|
      config.consumer_key        =  consumer_key
      config.consumer_secret     =  consumer_secret
      config.access_token        =  @config.access_token
      config.access_token_secret =  @config.access_token_secret
    end
  end
end
