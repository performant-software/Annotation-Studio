class AddConfigVariablesToTenant < ActiveRecord::Migration
  def change
    add_column :tenants, :site_name, :string
    add_column :tenants, :welcome_message, :string
    add_column :tenants, :welcome_blurb, :string
    add_column :tenants, :site_color, :string
    add_column :tenants, :brand, :string
    add_column :tenants, :wp_url, :string
    add_column :tenants, :wp_auth_key, :string
    add_column :tenants, :wp_auth_secret, :string
  end
end
