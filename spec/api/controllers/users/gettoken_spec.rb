require 'spec_helper'
require_relative '../../../../apps/api/controllers/users/gettoken'

describe Api::Controllers::Users::Gettoken do
  let(:action) { Api::Controllers::Users::Gettoken.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
