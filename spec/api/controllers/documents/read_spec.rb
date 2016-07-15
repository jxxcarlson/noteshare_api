require 'spec_helper'
require_relative '../../../../apps/api/controllers/documents/read'

describe Api::Controllers::Documents::Read do
  let(:action) { Api::Controllers::Documents::Read.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
