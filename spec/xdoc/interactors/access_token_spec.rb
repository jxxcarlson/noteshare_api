require 'spec_helper'
require 'jwt'

require_relative '../../../lib/xdoc/interactors/access_token'

describe AccessToken do

  before do

    UserRepository.clear
    CreateUser.new(username: 'fred', password: 'foobar1234',
                   password_confirmation: 'foobar1234', email: 'fred@foo.io').call
  end

  it 'returns an error if the user is not found: t1' do

    result = AccessToken.new(username: 'joe', password: 'foobar1234').call
    assert result.err[0] == ENV['ERRCODE_USER_NOT_FOUND']

  end

  it 'returns an error if the password is invalid: t2' do

    result = AccessToken.new(username: 'fred', password: 'foobar1111').call
    assert result.err[0] == ENV['ERRCODE_INVALID_PASSWORD']
    assert result.status == 401

  end


  it 'returns a JWT token for a valid username-password pair: t3' do

    result = AccessToken.new(username: 'fred', password: 'foobar1234').call
    decoded_token = JWT.decode result.token, nil, false
    puts "Encoded token: #{result.token}"
    puts "Decoded token: #{decoded_token}"
    assert decoded_token[1]['typ'] = 'JWT'
    assert result.status == 200

  end

end