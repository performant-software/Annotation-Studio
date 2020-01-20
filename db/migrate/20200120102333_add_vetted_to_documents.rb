class AddVettedToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :vetted, :boolean
  end
end
