class ChangeDocumentPublicationDate < ActiveRecord::Migration
  def change
    change_column :documents, :publication_date, :string
  end
end
