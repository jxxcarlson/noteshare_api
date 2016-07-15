
post '/documents', to: 'documents#create'          # create document from json payload
get '/documents/:id', to: 'documents#read'         # read document - get json payload
post '/documents/:id', to: 'documents#update'      # update document from json payload
delete '/documents/:id', to: 'documents#delete'   # delete document


# Configure your routes here
# See: http://www.rubydoc.info/gems/hanami-router/#Usage