class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def wordpress_hosted
    @user = User.find_for_wordpress_oauth2(request.env["omniauth.auth"], current_user)
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "NAVSA"
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
    else
      session["devise.wordpress_oauth2_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def setup
    @tenant = Tenant.current_tenant
    Rails.logger.info("**********Setup Started************")
    request.env['omniauth.strategy'].options[:client_id] = @tenant.wp_auth_key || ENV["WP_AUTH_KEY"]
    request.env['omniauth.strategy'].options[:client_secret] = @tenant.wp_auth_secret || ENV["WP_AUTH_SECRET"]
    request.env['omniauth.strategy'].options[:client_options].site = @tenant.wp_url || ENV["WP_URL"]
    render :text => "Setup complete.", :status => 404
  end

end
