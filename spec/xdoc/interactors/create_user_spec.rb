require 'spec_helper'

require_relative '../../../lib/xdoc/interactors/create_user'


describe CreateUser do

  before do
    UserRepository.clear
  end

  it 'can return username, email: t1' do

    result = CreateUser.new(username: 'fred', password: 'foobar', email: 'fred@foo.io').call
    assert result.username == 'fred'
    assert result.email == 'fred@foo.io'

  end


  it 'returns an error for a password which is too short: t3' do

    result = CreateUser.new(username: 'fred', password: 'aa',  email: 'fred@foo.io').call

    assert result.err[0] == ENV['ERRCODE_PASSWORD_TOO_SHORT']

  end

  it 'returns an error if email is not present: t4' do

    result = CreateUser.new(username: 'fred', password: 'abcd1234', password_confirmation: 'abcd1234').call
    assert result.err[0] == ENV['ERRCODE_EMAIL_MISSING']

  end

  it 'returns an error if email is not in proper formt: t5' do

    result = CreateUser.new(username: 'fred', password: 'abcd1234', email: 'fred.io').call
    assert result.err[0] == ENV['ERRCODE_EMAIL_INVALID']

  end

  it 'accepts a valid password and confirmation, the creates the user: t6' do

    result = CreateUser.new(username: 'fred', password: 'foobar1234', email: 'fred@foo.io').call
    assert result.err.must_be_nil
    assert result.user.username == 'fred'
    assert result.user.email == 'fred@foo.io'
    assert result.user.verify_password('foobar1234') == true
    assert result.user.admin == false
    assert result.user.dict == {}
    assert result.user.links == {}

  end

  it 'password works: t5' do

    result = CreateUser.new(username: 'fred', password: 'foobar1234',  email: 'fred@foo.io').call
    user = result.user
    assert BCrypt::Password.new(user.password_hash) == 'foobar1234'
    assert user.verify_password('foobar1234') == true

  end




end
