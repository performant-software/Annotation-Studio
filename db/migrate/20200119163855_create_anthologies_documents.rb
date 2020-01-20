class CreateAnthologiesDocuments < ActiveRecord::Migration
  def change
    create_table :anthologies_documents do |t|
      t.integer :anthology_id
      t.integer :document_id
    end
    add_index :anthologies_documents, :anthology_id
    add_index :anthologies_documents, :document_id
  end
end
