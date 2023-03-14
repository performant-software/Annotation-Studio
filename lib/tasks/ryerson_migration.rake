desc 'Migrate the Ryerson tenant to Toronto MU'
task :ryerson_migration => :environment do
  tenant = Apartment::Tenant.switch('ryerson') do
    User.all.each do |u|
      if u.email.include? '@ryerson.ca'
        # Make sure not to duplicate if the @torontumu account already exists
        existing = User.find_by(email: u.email.sub('@ryerson.ca', '@torontomu.ca'))

        if !existing
          u.email = u.email.sub('@ryerson.ca', '@torontomu.ca')
          u.save
        end
      end
    end
  end
end