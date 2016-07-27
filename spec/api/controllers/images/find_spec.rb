require 'spec_helper'
require_relative '../../../../apps/api/controllers/images/find'

describe Api::Controllers::Images::Find do
  let(:action) { Api::Controllers::Images::Find.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
