require 'spec_helper'
require_relative '../../../../apps/api/controllers/documents/delete'

describe Api::Controllers::Documents::Delete do
  let(:action) { Api::Controllers::Documents::Delete.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
