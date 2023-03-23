class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include AuthenticationHelper
  before_action :verify_authenticity_token, except: :saml

  def wordpress_hosted
    @user = User.find_for_wordpress_oauth2(request.env["omniauth.auth"], current_user)
    if @user.persisted?
      flash[:notice] = I18n.t("devise.omniauth_callbacks.success", :kind => $DOMAIN_CONFIG['oauth_provider'])
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
    else
      session["devise.wordpress_oauth2_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def saml
    @user = User.find_for_saml(request.env["omniauth.auth"], current_user)
    if @user.persisted?
      flash[:notice] = I18n.t("devise.omniauth_callbacks.success", :kind => $DOMAIN_CONFIG['saml_provider'])
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
    else
      session["devise.saml_auth_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def setup_wordpress_hosted
    @tenant = Tenant.current_tenant
    return unless allow_wordpress_oauth_authentication?(@tenant)
    
    if @tenant.present?
      Rails.logger.info("**********Setup Started for #{@tenant.database_name}************")
      Rails.logger.info("The tenant auth key is #{@tenant.wp_auth_key}")
      Rails.logger.info("The tenant secret is #{@tenant.wp_auth_secret}")
      Rails.logger.info("The tenant url is #{@tenant.wp_url}")
    end

    request.env['omniauth.strategy'].options[:client_id] = wp_auth_key(@tenant)
    request.env['omniauth.strategy'].options[:client_secret] = wp_auth_secret(@tenant)
    request.env['omniauth.strategy'].options[:client_options].site = wp_url(@tenant)

    render :plain => "Setup complete.", :status => 404
  end

  def setup_saml
    @tenant = Tenant.current_tenant
    return unless allow_saml_authentication?(@tenant)

    if @tenant.present?
      Rails.logger.info("**********Setup Started for #{@tenant.database_name}************")
      Rails.logger.info("The tenant auth key is #{@tenant.wp_auth_key}")
      Rails.logger.info("The tenant secret is #{@tenant.wp_auth_secret}")
      Rails.logger.info("The tenant url is #{@tenant.wp_url}")
    end

    request.env['omniauth.strategy'].options[:idp_cert_fingerprint] = idp_cert_fingerprint(@tenant)
    request.env['omniauth.strategy'].options[:idp_sso_target_url] = idp_sso_target_url(@tenant)
    request.env['omniauth.strategy'].options[:issuer] = url_for(action: 'metadata', controller: 'saml')
    request.env['omniauth.strategy'].options[:attribute_statements] = saml_attributes

    render :plain => "Setup complete.", :status => 404
  end

end
