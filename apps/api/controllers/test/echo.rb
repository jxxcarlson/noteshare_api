module Api::Controllers::Test
  class Echo
    include Api::Action

    def call(_params)
      dt = DateTime.now
      reply = { 'date' => dt.strftime("%D"), 'time' => dt.strftime("%H:%M:%S")}.to_json
      self.body = reply
    end
  end
end
