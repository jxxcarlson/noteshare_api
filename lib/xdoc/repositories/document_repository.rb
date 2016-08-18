require 'sequel'
require_relative '../../../lib/xdoc/modules/db_connection'

class DocumentRepository
  include Hanami::Repository
  include DBConnection

  def self.db
    Sequel.connect(ENV['XDOC_DATABASE_URL'])
  end

  def self.find_by_identifier(id)
    query do
      where(identifier: id)
    end.first
  end

  def self.find_public
    query do
      where(public: true)
    end
  end

  def self.find_public_by_owner(owner_id)
    query do
      where(owner_id: owner_id, public: true)
    end
  end

  def self.find_by_owner(owner_id)
    query do
      where(owner_id: owner_id)
    end
  end

  def self.find_by_tag(tag)
    self.db.fetch("SELECT id from documents WHERE tags @> '{#{tag}}';").map{ |item| DocumentRepository.find item[:id]}
  end

  def self.random_sample(percentage)
    self.db.fetch("SELECT * FROM documents TABLESAMPLE BERNOULLI(#{percentage})").map{ |item| DocumentRepository.find item[:id]}
  end

  def self.fuzzy_find_by_title2(title)
    # query do
    #  where(title: title)
    # end
    puts "db: #{self.db[:documents].inspect}"
    docs = self.db[:documents]
    filtered_docs = docs.grep(Sequel.function(:lower, :title), "%#{title}%")
    puts "In fuzzy_find_by_title, docs = #{docs.all.count}"
    puts "In fuzzy_find_by_title, filtered_docs = #{filtered_docs.all.count}"
    # docs.map{ |item| DocumentRepository.find item[:id]}
  end

  def self.fuzzy_find_by_title(title)
    self.db[:documents].grep(Sequel.function(:lower, :title), "%#{title}%").map{ |item| DocumentRepository.find item[:id]}
  end

  def self.find_by_owner_and_fuzzy_title(owner_id, title)
    puts "IN find_by_owner_and_fuzzy_title, owner_id = #{owner_id}, title = #{title}"
    hits = self.db[:documents].grep(Sequel.function(:lower, :title), "%#{title}%").where(owner_id: owner_id)
    puts "#{hits.count} items found"
    hits.map{ |item| DocumentRepository.find item[:id]}
  end

end
