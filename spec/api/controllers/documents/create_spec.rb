=begin

require 'spec_helper'
require_relative '../../../../apps/api/controllers/documents/create'

describe Api::Controllers::Documents::Create do
  let(:action) { Api::Controllers::Documents::Create.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end

=end
