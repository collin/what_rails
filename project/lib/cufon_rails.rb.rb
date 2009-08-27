module CufonRails
  class << self
    def routes(map)
      map.resources :fonts
    end
    
    def load_paths
      @load_paths ||= YAML.load(open(Rails.root+"config/cufon.yaml"))[:load_path].join(',')
    end
  end
  
  class Font < Pathname
    def create(name)
      self.glob("{#{CufonRails.load_paths}}/#{name}").first
    end
    
    def to_js
      `php -u "U+??" #{Rails.root+"vendor/cufon/generate/convert.php"} #{self}`
    end
  end
end

class FontsController < ActionController::Base
  caches_page :show
  respond_to :js
  
  def show filename
    respond_with CufonRails::Font.create(filename)
  end
end
