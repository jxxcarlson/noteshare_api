get '/signup', to: 'user#new'
get '/sessions', to: 'sessions#create'
get '/test', to: 'test#foo'

get '/foo', to: ->(env) { [200, {}, ['Welcome to Hanami::Router!']] }

get '/bar', to: ->(env) { [200, {}, ['<h1>Test of Router</h1>']] }

# Configure your routes here
# See: http://www.rubydoc.info/gems/hanami-router/#Usage