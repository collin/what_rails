class ApplicationController < ActionController::Base
  self.allow_forgery_protection = false

  helper :all # include all helpers, all the time
  helper_method :current_user
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation
  
  before_filter :set_return_to
   
  def set_return_to
    session[:return_to] = params[:return_to] if params[:return_to]
  end  
  
  def logged_in?
    current_user
  end
  
private
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to user_path(current_user)
      return false
    end
  end
  
  def store_location uri=request.request_uri
    session[:return_to] = uri
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  ##### iphone stuff
  before_filter :set_iphone_format
  
  def set_iphone_format
    request.format = :iphone if is_iphone_request?
  end
  
  def is_iphone_request?
    request.user_agent.match "iPhone"
  end
end