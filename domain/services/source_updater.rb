# SourceUpdater
class SourceUpdater
  def upsert(user)
    source = Source.find_by_id(user.id)
    if source.nil?
      Source.create(
        id: user.id,
        name: user.name,
        screen_name: user.screen_name,
        location: user.location,
        description: user.description,
        profile_background_image_url: user.profile_background_image_url,
        profile_image_url: user.profile_image_url)
    else
      source.update_from_user(user)
      source.save
    end
  end
end
