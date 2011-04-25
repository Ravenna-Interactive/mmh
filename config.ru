# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
# require 'huntapp_api'

run Rack::Cascade.new([
  # Huntapp::API,
  Huntapp::Application
])
