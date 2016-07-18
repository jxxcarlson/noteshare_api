require 'rubygems'
require 'bundler/setup'
require 'hanami/setup'
require_relative '../lib/xdoc'
require_relative '../apps/api/application'
require_relative '../apps/web/application'

Hanami::Container.configure do
  mount Api::Application, at: '/v1'
  mount Web::Application, at: '/'
end

# https://gitter.im/hanami/chat/archives/2016/02/12

