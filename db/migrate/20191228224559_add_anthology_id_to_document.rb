class AddAnthologyIdToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :anthology_id, :integer
    add_index :documents, :anthology_id
  end
end
