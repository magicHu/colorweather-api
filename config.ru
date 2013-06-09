# This file is used by Rack-based servers to start the application.

require 'sinatra'
require File.dirname(__FILE__)+'/lib/colorweather'

use Rack::Session::Cookie
run Rack::Cascade.new [Weather::API, Wechat::API]
