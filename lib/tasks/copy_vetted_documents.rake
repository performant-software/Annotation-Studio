desc 'Copy all vetted documents from source tenant to destination tenant'
task :copy_vetted_documents, [:source_tenant, :destination_tenant, :user_email, :dry_run]  => :environment do |t, args|
  args.with_defaults(:source_tenant => 'cove-studio')
  args.with_defaults(:destination_tenant => nil)
  args.with_defaults(:user_email => nil)
  args.with_defaults(:dry_run => nil)

  log_string = ''

  # declare arg variables
  starting_tenant = Apartment::Tenant.current
  user_email = args[:user_email]
  dry_run = args[:dry_run] || ENV['VETTED_DOC_DRY_RUN'] || "false"
  run_day = ENV['VETTED_DOC_RUN_DAY'].downcase || "sunday"
  run_frequency = ENV['VETTED_DOC_RUN_FREQUENCY'].downcase || "weekly"

  if run_frequency === "weekly" && Time.now.utc.strftime("%A").downcase != run_day
    raise Exception.new "The selected run day is #{run_day.capitalize}, but it is currently #{Time.now.utc.strftime("%A")} (UTC). Task will exit."
  end

  log_action(log_string, "Started at #{Time.now.strftime("%I:%M:%S")}")

  # Copy to all tenants if no destination is provided
  if !args[:destination_tenant]
    tenants = Apartment.tenant_names.select { |name| name != 'public-temp' }
    tenants.each do |tenant|
      copy_to_tenant(args[:source_tenant], tenant, user_email, log_string, dry_run)
    end
  else
    copy_to_tenant(args[:source_tenant], args[:destination_tenant], user_email, log_string, dry_run)
  end

  # switch back to starting tenant
  Apartment::Tenant.switch(starting_tenant)

  log_action(log_string, "Done at #{Time.now.strftime("%I:%M:%S")}")

  Delayed::Job.enqueue VettedDocumentsNotifierJob.new(log_string, dry_run)

end

# Messages will be logged to console and also put into a string for email alerts
def log_action(log_string, message)
  puts message
  log_string << "\n"
  log_string << message
end

def copy_to_tenant(source, destination, user_email, log_string, dry_run)

  # switch to source tenant
  Apartment::Tenant.switch(source)

  # gather all vetted documents from source tenant
  vetted_docs = Document.where(vetted: true).to_a

  # switch to destination tenant
  Apartment::Tenant.switch(destination)

  # copy each vetted document from source tenant to destination
  # tenant IF destination tenant does not already have a document
  # with the same slug,
  # preserve document slug, and
  # assign specified user OR default to User with id == 1
  copied_docs_count = 0
  skipped_doc_slugs = []

  existing_slugs = Document.all.pluck(:slug)

  vetted_docs.each do |doc|
    if existing_slugs.include?(doc.slug)
      skipped_doc_slugs << doc.slug
    else
      if dry_run != "true"
        new_doc = doc.deep_dup
        new_doc.slug = doc.slug
        new_doc.user_id = user_email && User.find_by(email: user_email)&.id || 1
        new_doc.save
      end
      copied_docs_count += 1
    end
  end

  if dry_run === "true"
    log_action(log_string, "DRY RUN: #{copied_docs_count} vetted documents would have been copied from #{source} to #{destination}")
  else
    log_action(log_string, "Copied #{copied_docs_count} vetted documents from #{source} to #{destination}")
  end

  if skipped_doc_slugs.present?
    if dry_run === "true"
      log_action(log_string, "DRY RUN: The following #{skipped_doc_slugs.count} documents would have been skipped:")
    else
      log_action(log_string, "Skipped the following #{skipped_doc_slugs.count} documents:")
    end
    skipped_doc_slugs.each { |slug| log_action(log_string, "   #{slug}") }
  end
end
