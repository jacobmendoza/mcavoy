RSpec.describe TwitterListTimeLineDownloader do
  describe 'when creating the command' do
    let(:wrapper) { double }
    let(:client) { double }
    let(:config) { double }
    let(:downloader) { TwitterListTimeLineDownloader.new(wrapper, config) }

    before do
      allow(wrapper).to receive(:client).and_return(client)
      allow(client).to receive(:list_timeline).and_return({})
      allow(config).to receive(:list_id).and_return(123_456)
    end

    it 'calls the twitter api' do
      downloader.download_timeline

      expect(client)
        .to have_received(:list_timeline)
        .with(123_456, count: 200)
    end

    it 'returns the result' do
      result = downloader.download_timeline
      expect(result).to_not be_nil
    end
  end
end
