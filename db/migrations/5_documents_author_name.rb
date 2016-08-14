Sequel.migration do
  up do
    add_column :documents, :author_name, String
  end

  down do
    drop_column :documents, :content_type
  end
end