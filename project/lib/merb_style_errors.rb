class ActionController::Base
  class HttpError < Exception 
    class << self; attr_reader :_code, :_action end 
    
    def action
      self.class.action || self.class.name.underscore
    end
    
    def status
      self.class.status
    end
    
    def controller
      "exceptions"
    end
    
    private
    def self.name
      @name ||= super.split('::').last
    end
    
    def self.status status = nil
      status ? @status = status : @status
    end
    
    def self.action action = nil
      action ? @action = action : @action
    end 
  end
  
  class BadRequest < HttpError
    status 400
  end
  
  class Unauthorized < HttpError
    status 401
  end
  
  class Forbidden < HttpError
    status 403
  end
  
  class NotFound < HttpError
    status 404
  end
  
  class Conflict < HttpError
    status 409
  end
  
  class InternalError < HttpError
    status 500
  end
  
  class Unavailable < HttpError
    status 503
  end
   
  rescue_from ActiveRecord::RecordNotFound do |exception|
    handle_error_merb_style 'not_found', 'exceptions'
  end
  
  rescue_from ActionController::UnknownAction do |exception|
    handle_error_merb_style 'not_found', 'exceptions'
  end
  
  rescue_from ActionController::RoutingError do |exception|
    handle_error_merb_style 'not_found', 'exceptions'
  end
  
  rescue_from HttpError do |exception|
    handle_error_merb_style exception.action, exception.controller
  end

  def handle_error_merb_style action, controller
    request.params["action"]     = action
    request.params["controller"] = controller
    ExceptionsController.process request, response
  end
end
