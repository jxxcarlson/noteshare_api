require 'spec_helper'
require_relative '../../../../apps/api/controllers/documents/find'

describe Api::Controllers::Documents::Find do
  let(:action) { Api::Controllers::Documents::Find.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
