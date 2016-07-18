require 'spec_helper'
require_relative '../../../../apps/web/controllers/user/new'

describe Web::Controllers::User::New do
  let(:action) { Web::Controllers::User::New.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
