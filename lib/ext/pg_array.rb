
require 'hanami/model/coercer'
require 'sequel'
require 'sequel/extensions/pg_array'


Sequel.extension :pg_array_ops
Sequel.extension :pg_hstore_ops


class PGIntArray < Hanami::Model::Coercer
  def self.dump(value)
    ::Sequel.pg_array(value, :integer)
  end

  def self.load(value)
    if value
      ::Kernel.Array(value)
    else
      []
    end
  end
end

class PGStringArray < Hanami::Model::Coercer
  def self.dump(value)
    ::Sequel.pg_array(value, :text)
  end

  def self.load(value)
    if value
      ::Kernel.Array(value)
    else
      []
    end
  end
end




