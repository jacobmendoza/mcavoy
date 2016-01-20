# Gets the retweets values for 75, 85 and 95 percentiles
# over an specified source.
class GetPercentilesForSourceService
  def initialize(
    builder = RtsOverTimeFunctionsBuilder.new,
    evaluator = RtsOverTimeFunctionsEvaluator.new,
    math_service = MathService.new)
    @builder = builder
    @evaluator = evaluator
    @math_service = math_service
  end

  def get(t, user_id)
    tweets_from_source = Tweet.find_all_by_user_id(user_id)

    functions = @builder.build_function(tweets_from_source)

    values_evaluated = @evaluator.evaluate(functions, t)

    result = {}
    [YELLOW, ORANGE, RED].each do |percentile|
      result[percentile] =
        @math_service.percentile(values_evaluated, percentile)
    end
    result
  end
end
