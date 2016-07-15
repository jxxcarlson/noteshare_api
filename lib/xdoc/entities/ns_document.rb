class NSDocument
  include Hanami::Entity

  attributes :id, :short_id, :owner_id, :collection_id, :title,
             :created_at, :updated_at, :viewed_at, :visit_count,
             :text, :rendered_text, :public, :dict, :kind, :links, :tags

  def set_links_from_array(array_name, array)
    @links[array_name] = array
  end

  def set_links_from_json(array_name, str)
    @links[array_name] = JSON.parse(str)
  end

  def get_links(array_name)
    @links[array_name]
  end

  def update_from_json(str)
    hash = JSON.parse(str)
    self.title = hash['title'] if hash['title']
    self.short_id = hash['short_id'] if hash['short_id']
    self.owner_id = hash['owner_id'] if hash['owner_id']
    self.collection_id = hash['collection_id'] if hash['collection_id']

    self.updated_at = Time.now.utc.iso8601
    self.viewed_at = hash['viewed_at'] if hash['viewed_at']
    self.visit_count = hash['visit_count'] if hash['visit_count']

    self.kind = hash['kind'] if hash['kind']
    self.text = hash['text'] if hash['text']
    self.rendered_text = hash['rendered_text'] if hash['rendered_text']

    self.public = hash['public'] if hash['public']

    self.dict = hash['dict'] if hash['dict']
    self.links['documents'] = hash['documents'] if hash['documents']
    self.links['resources'] = hash['resources'] if hash['resources']
    self.tags = hash['tags'] if hash['tags']
    DocumentRepository.update  self
  end

  def initialize(attributes = {})
    super
    @text ||= ''
    @rendered_text ||= ''
    @public ||= false
    @dict  ||= {}
    @kind ||= 'text'
    @links ||= {}
    @tags ||= []
  end


end
