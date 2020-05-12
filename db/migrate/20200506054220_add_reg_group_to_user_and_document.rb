class AddRegGroupToUserAndDocument < ActiveRecord::Migration
  def change
    add_column :users, :rep_group, :string
    add_column :documents, :rep_group, :string
  end
end
