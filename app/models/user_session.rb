require 'authlogic_api_token'

class UserSession < Authlogic::Session::Base
  include Authlogic::Session::ApiKey
  
  api_key_name 'X-USER-ACCESS-TOKEN'
  
  allow_http_basic_auth true
  
end