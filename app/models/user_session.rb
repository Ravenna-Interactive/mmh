require 'authlogic_api_token'

class UserSession < Authlogic::Session::Base
  include Authlogic::Session::ApiKey
  allow_http_basic_auth true
  
end