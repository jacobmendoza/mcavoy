# Small-quick-dirty in memory cache
# Could be replaced by a better mechanism in the future
class SimpleMemoryCache
  def initialize
    @data = {}
  end

  def add(key, expiration = Time.now + 5 * 60)
    fail ScriptError,
         'Block not provided adding to the cache' unless block_given?

    if record_is_present(key) || record_is_expired(key)
      new_value = yield
      @data.store key, expires: expiration, data_stored: new_value
      new_value
    else
      get(key)
    end
  end

  private

  def record_is_present(key)
    @data[key].nil?
  end

  def record_is_expired(key)
    !@data[key].nil? && @data[key][:expires] < Time.now
  end

  def get(key)
    @data[key][:data_stored]
  end
end
