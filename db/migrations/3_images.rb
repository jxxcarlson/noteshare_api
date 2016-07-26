require 'sequel'

Sequel.extension :migration

Sequel.migration do
  change do
    create_table(:images) do
      primary_key :id
      column :title, "text", :null=>false

      column :owner_id, "integer"

      column :created_at, "timestamp without time zone"
      column :updated_at, "timestamp without time zone"

      column :url, "text", :null=>false
      column :source, "text"

      column :public, "boolean"
      column :dict, "jsonb"
      column :tags, "text[]"
    end
  end
end

