# Returns the number of retweets required to be in a severity level
class SeverityLevelsForSourceRetriever
  def initialize(percentiles = GetPercentilesForSourceService.new)
    @percentiles = percentiles
  end

  def can_be_computed(user_id)
    @percentiles.can_be_computed(user_id)
  end

  def get(t, user_id)
    @percentiles.get(t, user_id)
  end
end
