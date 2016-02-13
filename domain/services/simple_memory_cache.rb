require 'singleton'
# Small-quick-dirty in memory cache
# Could be replaced by a better mechanism in the future
class SimpleMemoryCache
  include Singleton

  attr_accessor :default_expiration

  def initialize
    clear_cache
    @default_expiration = 5 * 60
  end

  def clear_cache
    @data = {}
  end

  def add(key, expiration = Time.now + @default_expiration)
    fail ScriptError,
         'Block not provided adding to the cache' unless block_given?

    if record_does_not_exist(key) || record_is_expired(key)
      new_value = yield
      @data.store key, expires: expiration, data_stored: new_value
      new_value
    else
      get(key)
    end
  end

  private

  def record_does_not_exist(key)
    @data[key].nil?
  end

  def record_is_expired(key)
    !@data[key].nil? && @data[key][:expires] < Time.now
  end

  def get(key)
    @data[key][:data_stored]
  end
end
