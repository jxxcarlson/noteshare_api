require 'sequel'

Sequel.extension :migration

Sequel.migration do
  change do
    create_table(:documents) do
      primary_key :id
      column :short_id, "text"
      column :title, "text", :null=>false

      column :owner_id, "integer"
      column :collection_id, "integer"

      column :created_at, "timestamp without time zone"
      column :updated_at, "timestamp without time zone"
      column :viewed_at, "timestamp without time zone"
      column :visit_count, "integer"

      column :text, "text", :null=>false
      column :rendered_text, "text"
    end
  end
end

