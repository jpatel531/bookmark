require 'data_mapper'
require 'sinatra'
require 'sinatra/flash'
require 'sinatra/partial'
require_relative 'models/link'
require_relative 'models/tag'
require_relative 'models/user'
require_relative 'data_mapper_setup'
require_relative 'helpers'
require_relative 'controllers/application'
require_relative 'controllers/links'
require_relative 'controllers/tags'
require_relative 'controllers/users'
require_relative 'controllers/sessions'

enable :sessions
set :session_secret, 'super secret encryption key'
set :partial_template_engine, :erb












