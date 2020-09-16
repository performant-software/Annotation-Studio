class ChangeTenantsAuthAllowedToArray < ActiveRecord::Migration
  def up
    change_column_default :tenants, :auth_allowed, nil
    change_column :tenants, :auth_allowed, :integer, array: true, default: [], null: false, using: 'ARRAY[auth_allowed]::INTEGER[]'
  end

  def down
    change_column_default :tenants, :auth_allowed, nil
    change_column :tenants, :auth_allowed, :integer, default: 0, null: false, using: 'COALESCE(auth_allowed[1], 0)'
  end
end
