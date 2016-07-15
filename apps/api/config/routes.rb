post '/documents/:id', to: 'documents#update'  # update document from json payload
post '/documents', to: 'documents#create'      # create document from json payload


# Configure your routes here
# See: http://www.rubydoc.info/gems/hanami-router/#Usage