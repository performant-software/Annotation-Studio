class AddGoogleAnalyticsCodeToTenant < ActiveRecord::Migration
  def change
    add_column :tenants, :google_analytics_code, :string
  end
end
