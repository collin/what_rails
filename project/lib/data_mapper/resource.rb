module DataMapper::Resource::ClassMethods
  def model_name
    name.underscore
  end
end