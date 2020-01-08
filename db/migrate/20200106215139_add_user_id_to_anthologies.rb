class AddUserIdToAnthologies < ActiveRecord::Migration
  def change
    add_column :anthologies, :user_id, :integer
    add_index :anthologies, :user_id
  end
end
