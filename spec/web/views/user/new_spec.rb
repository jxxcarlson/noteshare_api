require 'spec_helper'
require_relative '../../../../apps/web/views/user/new'

describe Web::Views::User::New do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/user/new.html.erb') }
  let(:view)      { Web::Views::User::New.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #foo' do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
