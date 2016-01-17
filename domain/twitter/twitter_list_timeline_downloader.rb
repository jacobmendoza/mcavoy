# TwitterListTimeLineDownloader
# Downloads the first 200 tweets from a list
class TwitterListTimeLineDownloader
  def initialize(
    wrapper = TwitterApiWrapper.new,
    config = ConfigurationLoader.new)
    @wrapper = wrapper
    @config = config
  end

  def download_timeline
    tweets = @wrapper.client.list_timeline(@config.list_id, count: 200)
    tweets
  end
end
