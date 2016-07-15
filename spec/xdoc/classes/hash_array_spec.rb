require 'spec_helper'
require_relative '../../../lib/xdoc/classes/hash_array'

include XDoc

describe HashArray do

  it 'can generate a list of values for a given attribute' do
    list = [ { 'id' => 10, 'title' => 'EM'}, { 'id' => 20, 'title' => 'Bio'}]
    oc = HashArray.new(list)
    assert oc.attribute_list('id') == [10, 20]
    assert oc.attribute_list('title') == ['EM', 'Bio']
  end

  it 'can serialize an object to json and deserialize it from json' do
    list = [ { 'id' => 10, 'title' => 'EM'}, { 'id' => 20, 'title' => 'Bio'}]
    oc = HashArray.new(list)
    json_str = oc.to_json
    oc2 = HashArray.from_json(json_str)
    json_str2 = oc2.to_json
    assert json_str2 == json_str
  end

  it 'can set the values for a given attribute' do
    list = [ { 'id' => 10, 'title' => 'EM'}, { 'id' => 20, 'title' => 'Bio'}]
    oc = HashArray.new(list)
    oc.set_attribute(0, 'title', 'QM')
    oc.set_attribute(0, 'note', 'OK')

    assert oc.attribute_list('title') == ['QM', 'Bio']
    assert oc.attribute_list('note') == ['OK', nil]
  end


end
