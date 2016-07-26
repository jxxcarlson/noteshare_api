require 'spec_helper'
require_relative '../../../../apps/api/views/images/get'

describe Api::Views::Images::Get do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/api/templates/images/get.html.erb') }
  let(:view)      { Api::Views::Images::Get.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #foo' do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
