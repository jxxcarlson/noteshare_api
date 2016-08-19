require 'sequel'
require_relative '../../../lib/xdoc/modules/db_connection'

class ImageRepository
  include Hanami::Repository

  def self.db
    Sequel.connect(ENV['XDOC_DATABASE_URL'])
  end

  def self.fuzzy_find_by_title(title)
    self.db[:images].grep(Sequel.function(:lower, :title), "%#{title}%").map{ |item| ImageRepository.find item[:id]}
  end

  def self.find_by_owner_and_fuzzy_title(owner_id, title)
    puts "IN find_by_owner_and_fuzzy_title, owner_id = #{owner_id}, title = #{title}"
    hits = self.db[:images].grep(Sequel.function(:lower, :title), "%#{title}%").where(owner_id: owner_id)
    puts "#{hits.count} items found"
    hits.map{ |item| ImageRepository.find item[:id]}
  end

  def self.random_sample(percentage)
    self.db.fetch("SELECT * FROM images TABLESAMPLE BERNOULLI(#{percentage})").map{ |item| ImageRepository.find item[:id]}
  end

end
