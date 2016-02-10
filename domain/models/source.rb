# Class representing a source
class Source
  include MongoMapper::Document

  key :name, String
  key :screen_name, String
  key :location, String
  key :description, String
  key :profile_background_image_url, String
  key :profile_image_url, String

  def update_from_user(user)
    self.name = user.name
    self.screen_name = user.screen_name
    self.location = user.location
    self.description = user.description
    self.profile_background_image_url = user.profile_background_image_url
    self.profile_image_url = user.profile_image_url
  end
end
