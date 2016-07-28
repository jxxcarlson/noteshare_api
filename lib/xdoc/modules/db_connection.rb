module DBConnection
  def self.included(base)
    def db
      instance_variable_get(:@adapter).instance_variable_get(:@connection)
    end
  end
end