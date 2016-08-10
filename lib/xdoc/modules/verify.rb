

module Permission

  def deny_access
    error_message = { "error" => "401 Access denied" }.to_json
    puts "error_message: #{error_message}"
    self.body = error_message
  end

  def verify(params)
    token = params['token']
    @access = GrantAccess.new(token).call
  end

  def error_document_response(kind='default')
    puts "error_document_reponse: #{kind}"
    default_document = DocumentRepository.find(ENV['DEFAULT_DOCUMENT_ID'])
    {'response' => '202 Accepted', 'document' => default_document.to_hash }
  end


end


