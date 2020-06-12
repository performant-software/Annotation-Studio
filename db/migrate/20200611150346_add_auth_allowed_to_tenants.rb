class AddAuthAllowedToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :auth_allowed, :integer, default: 0
  end
end
