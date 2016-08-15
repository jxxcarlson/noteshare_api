require 'hanami/model'
require 'hanami/mailer'

Dir["#{ __dir__ }/xdoc/**/*.rb"].each { |file| require_relative file }

require_relative 'ext/pg_array'

Hanami::Model.configure do
  ##
  # Database adapter
  #
  # Available options:
  #
  #  * Memory adapter
  #    adapter type: :memory, uri: 'memory://localhost/xdoc_development'
  #
  #  * SQL adapter
  #    adapter type: :sql, uri: 'sqlite://db/xdoc_development.sqlite3'
  #    adapter type: :sql, uri: 'postgres://localhost/xdoc_development'
  #    adapter type: :sql, uri: 'mysql://localhost/xdoc_development'
  #
  adapter type: :sql, uri: ENV['XDOC_DATABASE_URL']

  ##
  # Migrations
  #
  migrations 'db/migrations'
  schema     'db/schema.sql'

  ##
  # Database mapping
  #
  # Intended for specifying application wide mappings.
  #
  # You can specify mapping file to load with:
  #
  # mapping "#{__dir__}/config/mapping"
  #
  # Alternatively, you can use a block syntax like the following:
  #
  mapping do

    collection :documents do
      entity NSDocument
      repository DocumentRepository

      attribute :id, Integer
      attribute :identifier, String
      attribute :author_name, String
      attribute :title, String

      attribute :owner_id, Integer
      attribute :collection_id, Integer

      attribute :created_at, DateTime
      attribute :updated_at, DateTime
      attribute :viewed_at, DateTime
      attribute :visit_count, Integer


      attribute :text, String
      attribute :rendered_text, String

      attribute :public, Boolean
      attribute :dict, JSON
      attribute :tags, PGStringArray

      attribute :links, JSON
      attribute :kind, String

    end

    collection :images do
      entity Image
      repository ImageRepository

      attribute :id, Integer
      attribute :title, String

      attribute :owner_id, Integer

      attribute :created_at, DateTime
      attribute :updated_at, DateTime

      attribute :url, String
      attribute :content_type, String
      attribute :source, String
      attribute :public, Boolean

      attribute :dict, JSON
      attribute :tags, PGStringArray

    end

    collection :users do
      entity User
      repository UserRepository

      attribute :id, Integer
      attribute :username, String
      attribute :admin, Boolean
      attribute :status, String

      attribute :email, String
      attribute :password_hash, String

      attribute :created_at, DateTime
      attribute :updated_at, DateTime

      attribute :dict, JSON
      attribute :links, JSON

    end

  end


end.load!

Hanami::Mailer.configure do
  root "#{ __dir__ }/xdoc/mailers"

  # See http://hanamirb.org/guides/mailers/delivery
  delivery do
    development :test
    test        :test
    # production :stmp, address: ENV['SMTP_PORT'], port: 1025
  end
end.load!


