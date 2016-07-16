require 'spec_helper'
require_relative '../../../../apps/web/controllers/test/foo'

describe Web::Controllers::Test::Foo do
  let(:action) { Web::Controllers::Test::Foo.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
