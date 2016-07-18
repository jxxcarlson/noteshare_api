require 'sequel'

Sequel.extension :migration

Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      column :username, "text", :null=>false
      column :admin, "boolean"
      column :status, "text"
      column :email, "text"
      column :password_hash, "text"

      column :created_at, "timestamp without time zone"
      column :updated_at, "timestamp without time zone"

      column :dict, "jsonb"
      column :links, "jsonb"
    end
  end
end

