class Users::InvitationsController < Devise::InvitationsController
  before_filter :configure_permitted_parameters

  protected

    def configure_permitted_parameters
      # Only add some parameters
      devise_parameter_sanitizer.for(:accept_invitation).concat [:agreement, :firstname, :lastname]
    end
end
