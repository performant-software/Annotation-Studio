class RemoveAnthologyIdFromDocuments < ActiveRecord::Migration
  def change
    remove_column :documents, :anthology_id
  end
end
