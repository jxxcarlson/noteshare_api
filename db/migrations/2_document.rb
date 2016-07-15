require 'sequel'

Sequel.extension :migration

Sequel.migration do
  change do

    alter_table(:documents) do

      add_column :public, "boolean"
      add_column :dict, "jsonb"
      add_column :tags, "text[]"
      add_column :kind, "text"              # e.g., text, asciidoc, pdf, compilation

      add_column :links, "jsonb"

    end
  end
end

