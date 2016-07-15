require 'spec_helper'
require_relative '../../../../apps/api/controllers/documents/update'

describe Api::Controllers::Documents::Update do
  let(:action) { Api::Controllers::Documents::Update.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
