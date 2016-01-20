# Helper for building tweets updates for the tests
class ApiTweetUpdateBuilder
  attr_accessor :created_at, :retweet_count, :favorite_count

  def with_created_at(new_created_at)
    self.created_at = new_created_at
    self
  end

  def with_favorite_count(new_favorite_count)
    self.favorite_count = new_favorite_count
    self
  end

  def with_retweet_count(new_rt_count)
    self.retweet_count = new_rt_count
    self
  end
end
