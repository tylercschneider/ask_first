AskFirst.configure do |config|
  # Cookie settings
  config.cookie_name = "af_consent"
  config.cookie_expiry = 365 # days
  config.privacy_policy_url = "/privacy"

  # Whether to log consent records to the database
  config.log_consents = true

  # Define consent categories
  config.category :necessary do |c|
    c.title = "Strictly Necessary"
    c.description = "Essential for the website to function."
    c.required = true
    c.cookies = %w[_session_id _csrf_token]
  end

  config.category :analytics do |c|
    c.title = "Analytics"
    c.description = "Help us understand how visitors use the site."
    c.cookies = %w[_ga _ga_* _gid]
  end

  # config.category :marketing do |c|
  #   c.title = "Marketing"
  #   c.description = "Used to deliver relevant ads."
  #   c.cookies = %w[_fbp _fbc]
  # end
end
