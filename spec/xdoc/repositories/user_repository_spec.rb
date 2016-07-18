require 'spec_helper'

describe UserRepository do

  before do
    UserRepository.clear
  end

  it 'can retrieve a user by username' do

    user = User.new(username: 'fred')
    UserRepository.create user

    u = UserRepository.find_by_username 'fred'
    assert u.username == 'fred'

    v = UserRepository.find_by_username 'joe'
    assert v.must_be_nil

  end

end
