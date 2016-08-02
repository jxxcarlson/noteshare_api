class Image
  include Hanami::Entity

  attributes :id, :title, :owner_id, :created_at, :updated_at,
      :url, :source, :public, :dict, :tags, :content_type
end
