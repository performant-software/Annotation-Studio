class SendInvitesJob
  def initialize(user_id, tenant)
    @user_id = user_id
    @tenant = tenant
  end

  def perform
    original_tenant = Apartment::Tenant.current
    begin
      Apartment::Tenant.switch(@tenant)
      user = User.find(@user_id)
      Rails.logger.info "Sending email invite to #{user.email}..."
      tenant_domain = Tenant.find_by(database_name: @tenant).domain

      # Set the host to the current tenant
      ActionMailer::Base.default_url_options[:host] = tenant_domain

      user.deliver_invitation
    ensure
      # Reset both of the global settings we changed
      Apartment::Tenant.switch(original_tenant)
      ActionMailer::Base.default_url_options[:host] = { :host => ENV['EMAIL_DOMAIN'] }
    end
  end

  def max_attempts
    3
  end
end
