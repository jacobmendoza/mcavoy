# Represents a detailed model of a source that will be returned from the API
class NewsReportSourceDetailedModel
  attr_accessor :name, :screen_name, :location, :description,
                :profile_background_image_url, :profile_image_url

  def initialize(source)
    @name = source.name
    @screen_name = source.screen_name
    @location = source.location
    @description = source.description
    @profile_image_url = source.profile_image_url
    @profile_background_image_url = source.profile_background_image_url
  end
end
