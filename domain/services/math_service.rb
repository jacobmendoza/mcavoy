# Service that holds some mathematical operations
class MathService
  # Computes the value below which a given percentage of
  # observations may be found
  def percentile(values, percentile)
    return values[0] if values.length == 1
    values_sorted = values.sort
    k = (percentile * (values_sorted.length - 1) + 1).floor - 1
    f = (percentile * (values_sorted.length - 1) + 1).modulo(1)
    values_sorted[k] + (f * (values_sorted[k + 1] - values_sorted[k]))
  end
end
