

module Permission

  def deny_access
    error_message = { "error" => "401 Access denied" }.to_json
    puts "error_message: #{error_message}"
    self.body = error_message
  end

  def verify(params)
    token = params['token']
    @result = GrantAccess.new(token).call
  end

end


