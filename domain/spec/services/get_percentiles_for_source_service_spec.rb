RSpec.describe GetPercentilesForSourceService do
  let(:builder) { double }
  let(:evaluator) { double }
  let(:math_service) { double }
  let(:service) {
    GetPercentilesForSourceService.new(builder, evaluator, math_service)
  }

  describe 'When testing if percentiles can be computed' do
    it 'returns false if the operation cannot be done' do
      user_id = 1
      (1..(MINIMUM_RECORDS_TO_ALLOW_PERCENTILES - 1)).each do |i|
        Tweet.create(user_id: user_id)
      end
      expect(service.can_be_computed(user_id)).to eq false
    end

    it 'returns true if the operation can be done' do
      user_id = 1
      (1..(MINIMUM_RECORDS_TO_ALLOW_PERCENTILES)).each do |i|
        Tweet.create(user_id: user_id)
      end
      expect(service.can_be_computed(user_id)).to eq true
    end
  end

  describe 'When getting the percentiles for a source' do
    it 'returns the results' do
      t = 2
      user_id = 1
      percentiles = [1, 2, 3]
      values_evaluated = [20, 100]
      functions = [{ 1 => 10, 2 => 20 }, { 1 => 50, 2 => 100 }]

      first_tweet = Tweet.create(user_id: user_id)
      Tweet.create(user_id: 2)

      allow(builder)
        .to receive(:build_function)
        .with([first_tweet])
        .and_return(functions)

      allow(evaluator)
        .to receive(:evaluate)
        .with(functions, t)
        .and_return(values_evaluated)

      [YELLOW, ORANGE, RED].each_with_index { |percentile, i|
        allow(math_service)
          .to receive(:percentile)
          .with(values_evaluated, percentile)
          .and_return(percentiles[i])
      }

      result = service.get(t, user_id)

      [YELLOW, ORANGE, RED].each do |percentile|
        expect(math_service)
          .to have_received(:percentile)
          .with(values_evaluated, percentile)
      end

      expect(result[YELLOW]).to eq 1
      expect(result[ORANGE]).to eq 2
      expect(result[RED]).to eq 3
    end
  end
end
