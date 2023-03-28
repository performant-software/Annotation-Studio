class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :set_domain_config
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(user)
      @now = DateTime.current().to_time.iso8601
      session['jwt'] = JWT.encode(
          {
              'consumerKey' => ENV["API_CONSUMER"],
              'userId' => user.email,
              'issuedAt' => @now,
              'ttl' => 86400
          },
          ENV["API_SECRET"]
      )
      stored_location_for(user) || super
  end

  def authenticate
    redirect_to root_path, notice: "You need to be signed in" unless user_signed_in?
  end

  # Copied from Miximize!
  # https://github.com/ryanb/cancan/wiki/Exception-Handling
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render action: 404, status: :not_found
  end

  def current_tenant
    Apartment::Tenant.current
  end


  def set_domain_config
    $DOMAIN_CONFIG = DOMAIN_CONFIGS['public']
    if (DOMAIN_CONFIGS[request.host].present?)
      $DOMAIN_CONFIG = DOMAIN_CONFIGS[request.host]
    else
      $DOMAIN_CONFIG = DOMAIN_CONFIGS['default']
    end
  end


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:firstname, :lastname, :rep_group_list, :rep_subgroup_list, :affiliation])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:firstname, :lastname, :rep_group_list, :agreement, :affiliation])
  end

  # private
  # def set_domain_configs(args)
  #   Tenant.find_by(database_name: args).as_json
  # end
end
