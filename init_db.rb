Sequel.migration do
  change do
    create_table(:collections) do
      primary_key :id
      column :identifier, "text"
      column :owner_id, "integer"
      column :name, "text"

      column :created_at, "timestamp without time zone"
      column :updated_at, "timestamp without time zone"
      column :viewed_at, "timestamp without time zone"
      column :visit_count, "integer"

      column :dict, "jsonb"
      column :tags, "text[]"

      column :documents, "jsonb"
      column :collections, "jsonb"
      column :resources, "jsonb"
    end

    create_table(:documents) do
      primary_key :id
      column :identifier, "text"
      column :title, "text", :null=>false

      column :owner_id, "integer"
      column :collection_id, "integer"

      column :created_at, "timestamp without time zone"
      column :updated_at, "timestamp without time zone"
      column :viewed_at, "timestamp without time zone"
      column :visit_count, "integer"

      column :text, "text"
      column :rendered_text, "text"
      column :kind, "text"             # e.g.: text, asciidoc, pdf, compilation

      column :dict, "jsonb"
      column :tags, "text[]"

      column :visibility, "integer"

    end
  end
end

