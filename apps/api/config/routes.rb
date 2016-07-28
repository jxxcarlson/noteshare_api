post '/presigned', to: 'upload#psurl'

### IMAGES
###
get '/images', to: 'images#find'
get '/images/:id', to: 'images#get'




### DOCUMENTS
###
get '/documents', to: 'documents#find'             # find documents, return array of hashes
post '/documents', to: 'documents#create'          # create document from json payload
get '/documents/:id', to: 'documents#read'         # read document - get json payload
post '/documents/:id', to: 'documents#update'      # update document from json payload
delete '/documents/:id', to: 'documents#delete'    # delete document


### USERS
###
### References:
###
###    http://restcookbook.com/Basics/loggingin/
###
# get /users/joe?foo123 = authenticate user joe with password foo123 and return token
get '/users/:id', to: 'users#gettoken'
# post /users= create user joe with password foo123 and return token
post '/users/create', to: 'users#create'


# Configure your routes here
# See: http://www.rubydoc.info/gems/hanami-router/#Usage