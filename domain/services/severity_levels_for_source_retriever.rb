# Returns the number of retweets required to be in a severity level
class SeverityLevelsForSourceRetriever
  def initialize(
    percentiles = GetPercentilesForSourceService.new,
    cache = SimpleMemoryCache.instance)
    @percentiles = percentiles
    @cache = cache
  end

  def can_be_computed(user_id)
    cache_key = "levels.can_be_computed.#{user_id}"
    @cache.add(cache_key, Time.now + 60 * 60) { @percentiles.can_be_computed(user_id) }
  end

  def get(t, user_id)
    cache_key = "levels.get.#{t}.#{user_id}"
    @cache.add(cache_key, Time.now + 60 * 60) { @percentiles.get(t, user_id) }
  end
end
