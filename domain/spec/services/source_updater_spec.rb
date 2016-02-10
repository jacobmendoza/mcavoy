RSpec.describe SourceUpdater do
  let(:sut) { SourceUpdater.new }
  describe 'when inserting a new source' do
    let(:user) { ApiTweetUserBuilder.new }

    before do
      user.id = 123_456
      user.name = 'name'
      user.screen_name = 'screen_name'
      user.location = 'location'
      user.description = 'description'
      user.profile_background_image_url = 'profile_background_image_url'
      user.profile_image_url = 'profile_image_url'
    end

    it 'inserts a new source with the appropriate properties' do
      sut.upsert(user)

      source = Source.find_by_id(123_456)
      expect(source.id).to eq 123_456
      expect(source.name).to eq 'name'
      expect(source.screen_name).to eq 'screen_name'
      expect(source.location).to eq 'location'
      expect(source.description).to eq 'description'
      expect(source.profile_background_image_url).to eq 'profile_background_image_url'
      expect(source.profile_image_url).to eq 'profile_image_url'
    end

    it 'updates a new source with the appropriate updated parameters' do
      Source.create(id: 123_456)

      sut.upsert(user)

      source = Source.find_by_id(123_456)
      expect(source.id).to eq 123_456
      expect(source.name).to eq 'name'
      expect(source.location).to eq 'location'
      expect(source.description).to eq 'description'
      expect(source.profile_background_image_url).to eq 'profile_background_image_url'
      expect(source.profile_image_url).to eq 'profile_image_url'
    end
  end
end
