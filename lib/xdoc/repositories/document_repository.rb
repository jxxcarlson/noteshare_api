class DocumentRepository
  include Hanami::Repository

  def self.find_public
    query do
      where(public: true)
    end
  end

  def self.find_by_owner(owner_id)
    query do
      where(owner_id: owner_id)
    end
  end

end
