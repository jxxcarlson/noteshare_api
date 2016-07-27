require_relative '../../../../lib/xdoc/interactors/find_documents'

module Api::Controllers::Images
  class Find
    include Api::Action

    def call(params)
      puts "Search controller: #{request.query_string}"
      result = FindImages.new(request.query_string).call
      self.body = { :status => 200, :image_count => result.image_count, :images => result.image_hash_array }.to_json

    end

    def verify_csrf_token?
      false
    end

  end
end
