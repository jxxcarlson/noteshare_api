require 'spec_helper'

require_relative '../../../lib/xdoc/interactors/new_user'


describe NewUser do

  before do
    UserRepository.clear
  end

  it 'can return username, email: t1' do

    result = NewUser.new(username: 'fred', password: 'foobar', password_confirmation: 'jjjj', email: 'fred@foo.io').call
    assert result.username == 'fred'
    assert result.email == 'fred@foo.io'

  end

  it 'returns an error for a password - password confirmation mismatch: t2' do

    result = NewUser.new(username: 'fred', password: 'foobar', password_confirmation: 'jjjj', email: 'fred@foo.io').call
    puts "RESULT: #{result.inspect}"

    assert result.err[0] == ENV['ERRCODE_PASSWORD_MISSMATCH']

  end

  it 'returns an error for a password which is too short: t3' do

    result = NewUser.new(username: 'fred', password: 'aa', password_confirmation: 'aa', email: 'fred@foo.io').call
    puts "RESULT: #{result.inspect}"
    assert result.err[0] == ENV['ERRCODE_PASSWORD_TOO_SHORT']

  end

  it 'accepts a valid password and confirmation, the creates the user: t4' do

    result = NewUser.new(username: 'fred', password: 'foobar1234', password_confirmation: 'foobar1234', email: 'fred@foo.io').call
    # puts "RESULT: #{result.inspect}"
    assert result.err[0] == ENV['ERRCODE_OK']
    assert result.user.username == 'fred'
    assert result.user.email == 'fred@foo.io'
    assert result.user.verify_password('foobar1234') == true
    assert result.user.admin == false
    assert result.user.dict == {}
    assert result.user.links == {}

  end

  it 'pasword works: t5' do

    result = NewUser.new(username: 'fred', password: 'foobar1234', password_confirmation: 'foobar1234', email: 'fred@foo.io').call
    user = result.user
    assert BCrypt::Password.new(user.password_hash) == 'foobar1234'
    assert user.verify_password('foobar1234') == true


  end




end
