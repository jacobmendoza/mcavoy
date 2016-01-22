# Evaluates all the classes provided for an specific t
class RtsOverTimeFunctionsEvaluator
  def evaluate(fns, t)
    fns.map { |f| f[t] unless f[t].nil? }.compact
  end
end
