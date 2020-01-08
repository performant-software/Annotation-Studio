class AddSlugToAnthologies < ActiveRecord::Migration
  def change
    add_column :anthologies, :slug, :string
    add_index :anthologies, :slug, unique: true
  end
end
