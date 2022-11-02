class VettedDocumentsNotifierJob
  def initialize(log_string, dry_run)
    @log_string = log_string
    @dry_run = dry_run
  end

  def perform
    emails = ENV['ADMINS_TO_NOTIFY'].split(',')
    admins = AdminUser.where('email IN (?)', emails)

    admins.each do |admin|
      @admin = admin
      Rails.logger.info "emailing vetted documents logs to #{admin.email}..."
      if @dry_run === "true"
        VettedDocumentsMailer.dry_run_notification(@log_string, @admin).deliver_now
      else
        VettedDocumentsMailer.import_notification(@log_string, @admin).deliver_now
      end
    end
  end

  def max_attempts
    3
  end
end
