desc 'Migrate the Ryerson tenant to Toronto MU'
task :ryerson_migration => :environment do
  tenant = Apartment::Tenant.switch('test-ryerson') do
    User.all.each do |u|
      if u.email.include? '@ryerson.edu'
        u.email.sub! '@ryerson.edu' '@torontomu.ca'
        u.save
      end
    end
  end
end