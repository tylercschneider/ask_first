# AskFirst

Cookie consent management for Rails. A Rails engine wrapping [vanilla-cookieconsent](https://github.com/orestbida/cookieconsent) v3 with server-side consent logging, helpers, and middleware for GDPR/CCPA compliance.

## Features

- Configurable consent categories (necessary, analytics, marketing, etc.)
- Rack middleware parses consent cookie and sets `env["askfirst.consent"]`
- `consent_given?(:analytics)` helper for controllers and views
- `cookie_consent_tag` renders the consent banner via Stimulus + cookieconsent v3
- `POST /askfirst/consents` logs consent records to the database
- Respects the `Sec-GPC: 1` header (Global Privacy Control)
- Hotwire Native safe — banner is skipped for Turbo Native requests

## Requirements

- Ruby >= 3.1
- Rails >= 7.1
- Import maps (for JavaScript dependency management)

## Installation

Add to your Gemfile:

```ruby
gem "askfirst", github: "tylercschneider/askfirst"
```

Run the install generator:

```bash
bundle install
rails g askfirst:install
rails db:migrate
```

The generator will:
1. Create `config/initializers/askfirst.rb` with default configuration
2. Create a migration for the `askfirst_consent_records` table
3. Pin `vanilla-cookieconsent` via importmap
4. Copy the Stimulus controller to `app/javascript/controllers/askfirst/`

## Setup

Mount the engine in `config/routes.rb`:

```ruby
Rails.application.routes.draw do
  mount AskFirst::Engine, at: "/askfirst"
  # ...
end
```

Add the consent tag to your layout:

```erb
<!-- app/views/layouts/application.html.erb -->
<body>
  <%= cookie_consent_tag %>
  <%= yield %>
</body>
```

Add the cookieconsent stylesheet. In your layout or CSS:

```erb
<%= stylesheet_link_tag "https://cdn.jsdelivr.net/npm/vanilla-cookieconsent@3/dist/cookieconsent.css" %>
```

Or download it into your asset pipeline:

```bash
curl -o app/assets/stylesheets/cookieconsent.css \
  https://cdn.jsdelivr.net/npm/vanilla-cookieconsent@3/dist/cookieconsent.css
```

## Configuration

Edit `config/initializers/askfirst.rb`:

```ruby
AskFirst.configure do |config|
  config.cookie_name = "af_consent"        # consent cookie name
  config.cookie_expiry = 365               # days
  config.privacy_policy_url = "/privacy"
  config.log_consents = true               # write to DB

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

  config.category :marketing do |c|
    c.title = "Marketing"
    c.description = "Used to deliver relevant ads."
    c.cookies = %w[_fbp _fbc]
  end
end
```

## Usage

### Check consent in controllers

```ruby
class AnalyticsController < ApplicationController
  def track
    return head(:no_content) unless consent_given?(:analytics)

    # track event...
  end
end
```

### Check consent in views

```erb
<% if consent_given?(:analytics) %>
  <!-- Google Analytics snippet -->
<% end %>
```

### Consent records

Each time a user accepts or changes preferences, a record is logged to `askfirst_consent_records`:

```ruby
AskFirst::ConsentRecord.latest_for("visitor-123")
# => #<AskFirst::ConsentRecord visitor_id: "visitor-123", categories: {"analytics"=>true, "marketing"=>false}, ...>
```

## Middleware

The `AskFirst::Middleware` runs on every request:

1. Reads the consent cookie (default: `af_consent`)
2. Parses the JSON into `request.env["askfirst.consent"]`
3. If the `Sec-GPC: 1` header is present, overrides non-required categories to `false`

This makes `consent_given?` work in any controller or view without additional setup.

## Hotwire Native

`cookie_consent_tag` detects Turbo Native requests via user agent and returns an empty string. This means:

- No consent banner appears inside native app webviews
- Only necessary cookies are allowed (no consent cookie = empty consent hash)
- Native apps should handle consent through their own OS mechanisms (e.g., App Tracking Transparency on iOS)

## Development

```bash
bundle install
bundle exec rake test
```

## License

MIT
