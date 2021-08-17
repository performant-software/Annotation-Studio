desc 'Copy all vetted documents from source tenant to destination tenant'
task :copy_vetted_documents, [:source_tenant, :destination_tenant]  => :environment do |t, args|

  # set tenant variables
  source = args[:source_tenant]
  destination = args[:destination_tenant]
  starting_tenant = Apartment::Tenant.current

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
  # remove user_id as this is tenant-specific
  copied_docs_count = 0
  vetted_docs.each do |doc|
    unless Document.where(slug: doc.slug).present?
      new_doc = doc.deep_dup
      new_doc.slug = doc.slug
      new_doc.user_id = nil
      new_doc.save
      copied_docs_count += 1
    end
  end

  puts "Copied #{copied_docs_count} vetted documents from #{source} to #{destination}"

  # switch back to starting tenant
  Apartment::Tenant.switch(starting_tenant)
end
