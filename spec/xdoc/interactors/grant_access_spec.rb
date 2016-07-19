require 'spec_helper'
require 'jwt'
require 'benchmark'

require_relative '../../../lib/xdoc/interactors/access_token'
require_relative '../../../lib/xdoc/interactors/grant_access'

describe GrantAccess do

  before do

    UserRepository.clear
    CreateUser.new(username: 'fred', password: 'foobar1234',
                   password_confirmation: 'foobar1234', email: 'fred@foo.io').call
  end


  it 'returns true if the access token is valid' do

    access_token = AccessToken.new(username: 'fred', password: 'foobar1234').call.token
    result = GrantAccess.new(access_token).call
    assert result.valid == true
    assert result.status == 200

  end

  it 'returns false if the access token is invalid' do

    access_token = AccessToken.new(username: 'fred', password: 'foobar1234').call.token
    access_token = access_token + '1'
    result = GrantAccess.new(access_token).call
    assert result.valid == false
    assert result.status == 401

  end

  it 'can be benchmarked' do
    # Reference: http://rubylearning.com/blog/2013/06/19/how-do-i-benchmark-ruby-code/

    iterations = 1

    Benchmark.bm do |bm|

      bm.report do
        iterations.times do
          access_token = AccessToken.new(username: 'fred', password: 'foobar1234').call.token
          access_token = access_token + '1'
          GrantAccess.new(access_token).call
        end
      end

    end
  end

end