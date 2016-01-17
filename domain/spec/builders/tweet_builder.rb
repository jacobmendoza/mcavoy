# Helper for building tweets for the tests
class TweetBuilder
  attr_accessor :id, :created_at, :source_created_at,
                :text, :user, :retweet_count, :favorite_count

  def initialize
    self.user = TweetUserBuilder.new
  end

  def with_id(new_id)
    self.id = new_id
    self
  end

  def with_created_at(new_created_at)
    self.created_at = new_created_at
    self
  end

  def with_source_created_at(new_source_created_at)
    self.source_created_at = new_source_created_at
    self
  end

  def with_text(new_text)
    self.text = new_text
    self
  end

  def with_user_id(new_user_id)
    user.id = new_user_id
    self
  end

  def with_user_name(new_user_name)
    user.name = new_user_name
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
