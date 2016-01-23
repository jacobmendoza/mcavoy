RSpec.describe SeverityLevelsForSourceRetriever do
  let(:percentiles) { double }
  let(:retriever) { SeverityLevelsForSourceRetriever.new(percentiles) }
  describe 'When testing if they can be computed' do
    it 'calls the appropriate service' do
      expect(percentiles).to receive(:can_be_computed).with(123456)
      retriever.can_be_computed(123456)
    end
  end

  describe 'When getting the severity thresholds' do
    it 'calls the appropriate service' do
      expect(percentiles).to receive(:get).with(1, 123456)
      retriever.get(1, 123456)
    end
  end
end
