# Changelog

## 0.1.0

- Initial release
- Configurable consent categories (necessary, analytics, marketing, etc.)
- Rack middleware parses consent cookie and sets `env["ask_first.consent"]`
- `consent_given?(:analytics)` helper for controllers and views
- `cookie_consent_tag` renders the consent banner via Stimulus + cookieconsent v3
- Server-side consent logging to database
- Global Privacy Control (`Sec-GPC: 1`) support
- Hotwire Native detection — banner skipped for Turbo Native requests
- Install generator with initializer, migration, importmap pin, and Stimulus controller
