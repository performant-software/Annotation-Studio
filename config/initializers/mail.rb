if ['production', 'staging', 'public'].include?(Rails.env)
  ActionMailer::Base.delivery_method = :postmark
end
