class UserSession < Authlogic::Session::Base
  include DMAuthlogicSession
end