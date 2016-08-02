Sequel.migration do
  up do
    add_column :images, :content_type, String
  end

  down do
    drop_column :images, :content_type
  end
end