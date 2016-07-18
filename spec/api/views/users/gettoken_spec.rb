require 'spec_helper'
require_relative '../../../../apps/api/views/users/gettoken'

describe Api::Views::Users::Gettoken do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/api/templates/users/gettoken.html.erb') }
  let(:view)      { Api::Views::Users::Gettoken.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #foo' do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
