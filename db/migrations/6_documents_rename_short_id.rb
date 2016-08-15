Sequel.migration do
  up do
    rename_column :documents, :identifier, :identifier
  end

  down do
    rename_column :documents, :identifier, :identifier
  end
end