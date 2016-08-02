require 'spec_helper'
require_relative '../../../../apps/api/controllers/images/create'

describe Api::Controllers::Images::Create do
  let(:action) { Api::Controllers::Images::Create.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
