Class User
  include DataMapper::Resource
  include DMAuthlogic
  
  is_gravtastic! :default => "identicon"
  
  def profile_image_url
    gravatar_url
  end
end