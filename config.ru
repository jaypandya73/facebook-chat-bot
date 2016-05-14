# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)
run Rails.application


require 'facebook/messenger'
require_relative 'bot'

run Facebook::Messenger::Server