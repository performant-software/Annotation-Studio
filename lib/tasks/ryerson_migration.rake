desc 'Migrate the Ryerson tenant to Toronto MU'
task :ryerson_migration => :environment do
  tenant = Apartment::Tenant.switch('ryerson') do
    User.all.each do |u|
      if u.email.include? '@ryerson.ca'
        u.email.sub! '@ryerson.ca' '@torontomu.ca'
        u.save
      end
    end
  end
end