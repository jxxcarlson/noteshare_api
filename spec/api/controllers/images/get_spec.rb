require 'spec_helper'
require_relative '../../../../apps/api/controllers/images/get'

describe Api::Controllers::Images::Get do
  let(:action) { Api::Controllers::Images::Get.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
