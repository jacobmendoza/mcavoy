require 'timecop'
RSpec.describe SimpleMemoryCache do
  describe 'when inserting a new pair' do
    let(:sut) { SimpleMemoryCache.instance }
    let(:default_expiration) { 5 * 60 }

    before do
      sut.clear_cache
      sut.default_expiration = default_expiration
    end

    it 'raises an exception if the block has not been provided' do
      expect { sut.add('key') }.to raise_error ScriptError
    end

    it 'inserts the new key' do
      value = sut.add('key') { ['value'] }
      expect(value).to eq ['value']
    end

    it 'gets the value if the key is present' do
      sut.add('key') { ['cached_value'] }
      # Not sure if this is the best way, but verifying that the block
      # has not been executed by providing a different value in the second
      # call. ['cached_value'] must be returned from the cache.
      value = sut.add('key') { ['new_value'] }
      expect(value).to eq ['cached_value']
    end

    it 'executes the block again if the key has expired with default time' do
      now = Time.now
      sut.add('key') { ['cached_value'] }
      Timecop.travel(now + default_expiration) do
        value = sut.add('key') { ['new_value'] }
        expect(value).to eq ['new_value']
      end
    end

    it 'executes the block again if the key has expired with custom time' do
      now = Time.now
      sut.add('key', now + 10 * 60) { ['cached_value'] }
      Timecop.travel(now + 10 * 60) do
        value = sut.add('key') { ['new_value'] }
        expect(value).to eq ['new_value']
      end
    end
  end
end
