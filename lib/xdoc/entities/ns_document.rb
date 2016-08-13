class NSDocument
  include Hanami::Entity

  attributes :id, :short_id, :owner_id, :collection_id, :title,
             :created_at, :updated_at, :viewed_at, :visit_count,
             :text, :rendered_text, :public, :dict, :kind, :links, :tags

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

  def set_links_from_array(array_name, array)
    @links[array_name] = array
  end

  def set_links_from_json(array_name, str)
    @links[array_name] = JSON.parse(str)
  end

  def get_links(array_name)
    @links[array_name]
  end


  ###
  ### JSON
  ###

  def to_hash
    hash = {}
    hash['id'] = self.id
    hash['short_id'] = self.short_id
    hash['collection_id'] = self.collection_id

    hash['title'] = self.title

    hash['created_at'] = self.created_at.to_s
    hash['updated_at'] = self.updated_at.to_s
    hash['viewed_at'] = self.viewed_at.to_s
    hash['visit_count'] = self.visit_count

    hash['kind'] = self.kind
    hash['text'] = self.text
    hash['rendered_text'] = self.rendered_text

    hash['public'] = self.public
    hash['dict'] = self.dict
    hash['links'] = self.links
    hash['tags'] = self.tags
    hash
  end

  def to_json
    self.to_hash.to_json
  end

  def update_from_json(str)
    hash = JSON.parse(str)
    self.update_from_hash(hash)
  end

  def update_from_hash(hash)

    puts "update_from_hash: #{hash.to_s}"

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

    self.public = hash['public'] if hash['public'] != nil
    puts "hash['public'] = #{hash['public']}"
    puts "self.public = #{self.public}"

    self.dict = hash['dict'] if hash['dict']
    self.links['documents'] = hash['links']['documents'] if hash['links'] && hash['links']['documents']
    self.links['resources'] = hash['links']['resources'] if hash['links'] && hash['links']['resources']
    self.tags = hash['tags'] if hash['tags']
    DocumentRepository.update  self
  end




end
