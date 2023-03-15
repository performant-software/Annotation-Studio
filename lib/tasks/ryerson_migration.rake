desc 'Migrate the Ryerson tenant to Toronto MU'
task :ryerson_migration, [:dry_run] => :environment do |t, args|
  args.with_defaults(:dry_run => nil)

  if args[:dry_run]
    puts 'Running a dry run. No data will be written to the database.'
  end

  tenant = Apartment::Tenant.switch('ryerson') do
    User.all.each do |u|
      if u.email.include? '@ryerson.ca'
        # Make sure not to duplicate if the @torontumu account already exists
        existing = User.find_by(email: u.email.sub('@ryerson.ca', '@torontomu.ca'))

        if !existing
          u.email = u.email.sub('@ryerson.ca', '@torontomu.ca')
          if args[:dry_run]
            puts u.inspect
          else
            u.skip_reconfirmation!
            u.save
          end
        end
      end
    end
  end
end