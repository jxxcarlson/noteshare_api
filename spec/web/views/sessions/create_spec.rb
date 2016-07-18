require 'spec_helper'
require_relative '../../../../apps/web/views/sessions/create'

describe Web::Views::Sessions::Create do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/sessions/create.html.erb') }
  let(:view)      { Web::Views::Sessions::Create.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #foo' do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
