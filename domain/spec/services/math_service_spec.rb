RSpec.describe MathService do
  let(:service) { MathService.new }

  describe 'when creating the service' do
    it 'can be created' do
      expect(service).to_not be_nil
    end
  end

  describe 'when computing percentiles' do
    it 'can compute percentile 25' do
      result = service.percentile([1,2,3,4,5], 0.25)
      expect(result).to eq 2.0
    end

    it 'can compute percentile 75' do
      result = service.percentile([1,2,3,4,5], 0.75)
      expect(result).to eq 4.0
    end

    it 'can interpolate when computing percentile' do
      result = service.percentile([1,2,3,4,5], 0.95)
      expect(result).to eq 4.8
    end
  end
end
