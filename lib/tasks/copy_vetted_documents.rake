desc 'Copy all vetted documents from source tenant to destination tenant'
task :copy_vetted_documents, [:source_tenant, :destination_tenant, :user_email]  => :environment do |t, args|
  args.with_defaults(:source_tenant => 'cove-studio')
  args.with_defaults(:destination_tenant => nil)
  args.with_defaults(:user_email => nil)

  puts "Started at #{Time.now.strftime("%I:%M:%S")}"

  # declare arg variables
  starting_tenant = Apartment::Tenant.current
  user_email = args[:user_email]

  # Copy to all tenants if no destination is provided
  if !args[:destination_tenant]
    tenants = Apartment.tenant_names.select { |name| name != 'public-temp' }
    tenants.each do |tenant|
      copy_to_tenant(args[:source_tenant], tenant, user_email)
    end
  else
    copy_to_tenant(args[:source_tenant], args[:destination_tenant], user_email)
  end

  # switch back to starting tenant
  Apartment::Tenant.switch(starting_tenant)
  
  puts "Done at #{Time.now.strftime("%I:%M:%S")}"
end

def copy_to_tenant(source, destination, user_email)
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
      new_doc = doc.deep_dup
      new_doc.slug = doc.slug
      new_doc.user_id = user_email && User.find_by(email: user_email)&.id || 1
      new_doc.save
      copied_docs_count += 1
    end
  end

  puts "Copied #{copied_docs_count} vetted documents from #{source} to #{destination}"

  if skipped_doc_slugs.present?
    puts "Skipped the following #{skipped_doc_slugs.count} documents:"
    skipped_doc_slugs.each { |slug| puts "   #{slug}" }
  end
end