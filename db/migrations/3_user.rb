require 'sequel'

Sequel.extension :migration

Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      column :user_name, "text", :null=>false
      column :admin, "boolean"
      column :status, "text"
      column :email, "text"
      column :password, "text"

      column :created_at, "timestamp without time zone"
      column :updated_at, "timestamp without time zone"
      column :viewed_at, "timestamp without time zone"     # drop this

      column :dict, "jsonb"
      column :links, "jsonb"
    end
  end
end

