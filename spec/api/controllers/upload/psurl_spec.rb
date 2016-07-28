require 'spec_helper'
require_relative '../../../../apps/api/controllers/upload/psurl'

describe Api::Controllers::Upload::Psurl do
  let(:action) { Api::Controllers::Upload::Psurl.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
