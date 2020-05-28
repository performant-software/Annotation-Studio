class RemoveRepGroupFields < ActiveRecord::Migration
  def change
    remove_column :users, :rep_group
    remove_column :documents, :rep_group
  end
end
