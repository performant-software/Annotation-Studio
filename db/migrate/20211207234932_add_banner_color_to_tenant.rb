class AddBannerColorToTenant < ActiveRecord::Migration
  def change
    add_column :tenants, :banner_color, :string
  end
end
