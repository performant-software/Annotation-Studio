class VettedDocumentsMailer < ApplicationMailer
  def import_notification(log_string, admin_user)
    @log_string = log_string
    @admin_user = admin_user
    mail(to: @admin_user.email, subject: 'Vetted documents imported')
  end

  def dry_run_notification(log_string, admin_user)
    @log_string = log_string
    @admin_user = admin_user
    mail(to: @admin_user.email, subject: 'Vetted document dry run completed')
  end
end
