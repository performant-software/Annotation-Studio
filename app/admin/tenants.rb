ActiveAdmin.register Tenant do
  permit_params :domain, :database_name, :mel_catalog_enabled, :mel_catalog_url, :annotation_categories_enabled,
                :site_name, :welcome_message, :welcome_blurb, :site_color, :brand, :wp_url, :wp_auth_key,
                :wp_auth_secret, :idp_sso_target_url, :idp_cert_fingerprint, :google_analytics_code, :banner_color, auth_allowed: []

  scope :all, :default => true

  filter :domain
  filter :mel_catalog_enabled
  filter :mel_catalog_url
  filter :annotation_categories_enabled
  filter :database_name
  filter :site_name
  filter :welcome_message
  filter :site_color
  filter :brand
  filter :auth_allowed

  index do
    selectable_column
    column "Domain", :domain
    column "Mel Catalog", :mel_catalog_enabled
    column "Mel Catalog Url", :mel_catalog_url
    column "DB name", :database_name
    column "Site Name", :site_name
    column "Welcome Message", :welcome_message
    column "Site Color", :site_color
    column "Brand", :brand
    column "Auth Allowed" do |tenant|
      tenant.auth_allowed && tenant.auth_allowed.map{ |a| I18n.t("authentication.#{Tenant::AUTHORIZATION_METHODS.key(a)}") }.join(', ')
    end
    actions
  end

  form do |f|
    f.inputs "Tenant Details" do
      f.input :domain, :as => :string, label: 'The domain, ex - "app.example.com":'
      f.input :mel_catalog_enabled, :as => :boolean, label: 'Enables MEL Catalog features'
      f.input :mel_catalog_url, :as => :string, label: 'The full url, ex - "http://mel-catalog.herokuapp.com/api/"'
      f.input :annotation_categories_enabled, :as => :boolean, label: 'Enables Annotation Categories'
      f.input :database_name, :as => :string, label: 'The internal database name, ex - "app":'
      f.input :site_name, :as => :string, label: 'Enter Site name:'
      f.input :welcome_message, :as => :string, label: 'Welcome message for this tenant:'
      f.input :welcome_blurb, :as => :string, label: 'Welcome blurb for this tenant:'
      f.input :site_color, :as => :color, label: 'Customize a site color (Hex Code):'
      f.input :banner_color, :as => :color, label: 'Customize a banner background color (Hex Code):'
      f.input :brand, :as => :string, label: 'Enter the brand'
      f.input :wp_url, :as => :string, label: 'Enter WordPress hosted Url'
      f.input :wp_auth_key, :as => :string, label: 'Enter WordPress Auth Key'
      f.input :wp_auth_secret, :as => :string, label: 'Enter WordPress Auth Secret'
      f.input :idp_cert_fingerprint, as: :string, label: 'IDP Certificate Fingerprint'
      f.input :idp_sso_target_url, as: :string, label: 'IDP SSO Target URL'
      f.input :auth_allowed, as: :check_boxes, multiple: true,
              collection: Tenant::AUTHORIZATION_METHODS.keys.map { |k| [I18n.t("authentication.#{k}"), Tenant::AUTHORIZATION_METHODS[k]] }
      f.input :google_analytics_code, as: :string, label: 'Google Analytics code'
    end
    f.actions do
      f.action :submit,
               button_html: {
                   label: 'Custom label',
                   class: "btn primary",
                   data: {disable_with:  'Creating...'}
               }
      f.action :cancel, :wrapper_html => { :class => "cancel" }
    end
  end

  controller do
    before_save do |tenant|
      tenant.auth_allowed = params[:tenant][:auth_allowed].reject { |a| a.empty? } if params[:tenant][:auth_allowed].present?
    end
  end
end
