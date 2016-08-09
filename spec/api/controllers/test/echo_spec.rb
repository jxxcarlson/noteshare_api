require 'spec_helper'
require_relative '../../../../apps/api/controllers/test/echo'

describe Api::Controllers::Test::Echo do
  let(:action) { Api::Controllers::Test::Echo.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
