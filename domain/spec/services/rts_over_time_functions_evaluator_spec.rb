RSpec.describe RtsOverTimeFunctionsEvaluator do
  let(:evaluator) { RtsOverTimeFunctionsEvaluator.new }

  describe 'when creating the evaluator' do
    it 'can be created' do
      expect(evaluator).to_not be_nil
    end
  end

  describe 'when evaluating the functions for some specific t' do
    it 'returns the records' do
      fn1 = { 1 => 10, 2 => 20, 3 => 30 }
      fn2 = { 1 => 10, 2 => 15, 3 => 40 }
      fn3 = { 1 => 10, 2 => 30 }

      result = evaluator.evaluate([fn1, fn2, fn3], 2)

      expect(result[0]).to eq 20
      expect(result[1]).to eq 15
      expect(result[2]).to eq 30
    end
  end
end
