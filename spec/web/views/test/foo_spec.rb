require 'spec_helper'
require_relative '../../../../apps/web/views/test/foo'

describe Web::Views::Test::Foo do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/test/foo.html.erb') }
  let(:view)      { Web::Views::Test::Foo.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #foo' do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
