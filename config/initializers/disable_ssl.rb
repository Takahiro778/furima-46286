if Rails.env.production?
  Rails.application.config.force_ssl = false
end
