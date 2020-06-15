class AddSamlConfigVariablesToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :idp_sso_target_url, :string
    add_column :tenants, :idp_cert_fingerprint, :string
  end
end
