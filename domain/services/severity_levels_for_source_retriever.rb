# Returns the number of retweets required to be in a severity level
class SeverityLevelsForSourceRetriever
  def initialize(
    percentiles = GetPercentilesForSourceService.new,
    cache = SimpleMemoryCache.new)
    @percentiles = percentiles
    @cache = cache
  end

  def can_be_computed(user_id)
    cache_key = "levels.can_be_computed.#{user_id}"
    @cache.add(cache_key) { @percentiles.can_be_computed(user_id) }
  end

  def get(t, user_id)
    cache_key = "levels.get.#{t}.#{user_id}"
    @cache.add(cache_key) { @percentiles.get(t, user_id) }
  end
end
