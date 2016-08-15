Sequel.migration do
  up do
    rename_column :documents, :short_id, :identifier
  end

  down do
    rename_column :documents, :identifier, :short_id
  end
end