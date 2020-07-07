require 'yaml'

namespace :annotationstudio do
	desc "Set all the user passwords for development"
	task :reset_passwords => :environment do
		users = User.all
		puts "Resetting the passwords for #{users.count} users."
		users.each_with_index { |user,x|
			user.password = "super-secret"
			user.save!
			if x % 1000 == 0
				puts ''
				print "#{x}: "
			elsif x % 100 == 0
				print '+'
			elsif x % 10 == 0
				print '.'
			end
    }
  end

  desc "Load data form domain specific config into DB"
  task :load_domain_specific_config => :environment do
		my_logger = Logger.new(STDOUT)
		TENANT_CONFIGS = YAML.load_file(Rails.root.join('config', 'domain_specific' , 'config.yml'))
		my_logger.info "***There are #{TENANT_CONFIGS.count} tenants to be created.***"
		TENANT_CONFIGS.each do |key, value|
				tenant = Tenant.find_or_initialize_by(database_name: key) do |t|
					t.domain = "#{key}.itsdomain.com: change later fast"
					t.site_name = value["site_name"]
					t.welcome_message = value["welcome_message"]
					t.welcome_blurb = value["welcome_blurb"]
					t.site_color = value["site_color"]
					t.brand = value["brand"]
				end
        if tenant.save!
					my_logger.info "Tenant #{key} created!!!"
        else
					my_logger.info "Tenant #{key} creation Failed!!!"
				end
		end
	end
end