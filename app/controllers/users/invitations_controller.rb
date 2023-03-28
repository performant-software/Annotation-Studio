class Users::InvitationsController < Devise::InvitationsController
  before_action :configure_permitted_parameters

  protected

    def configure_permitted_parameters
      # Only add some parameters
      devise_parameter_sanitizer.permit(:accept_invitation, keys: [:agreement, :firstname, :lastname])
    end
end
