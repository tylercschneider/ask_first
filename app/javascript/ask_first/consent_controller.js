import { Controller } from "@hotwired/stimulus"
import * as CookieConsent from "vanilla-cookieconsent"

export default class extends Controller {
  static values = {
    config: Object,
    endpoint: String
  }

  connect() {
    this.initCookieConsent()
  }

  initCookieConsent() {
    const config = this.configValue
    const categories = this.buildCategories(config.categories || {})

    CookieConsent.run({
      categories: categories,

      cookie: {
        name: config.cookie_name || "af_consent",
        expiresAfterDays: config.cookie_expiry || 365
      },

      guiOptions: {
        consentModal: {
          layout: "box",
          position: "bottom left"
        },
        preferencesModal: {
          layout: "box"
        }
      },

      language: {
        default: "en",
        translations: {
          en: {
            consentModal: {
              title: "We use cookies",
              description: "This site uses cookies to improve your experience. You can choose which categories to allow.",
              acceptAllBtn: "Accept all",
              acceptNecessaryBtn: "Reject all",
              showPreferencesBtn: "Manage preferences"
            },
            preferencesModal: {
              title: "Cookie preferences",
              acceptAllBtn: "Accept all",
              acceptNecessaryBtn: "Reject all",
              savePreferencesBtn: "Save preferences",
              sections: this.buildSections(config)
            }
          }
        }
      },

      onConsent: () => this.logConsent(),
      onChange: () => this.logConsent()
    })
  }

  buildCategories(configCategories) {
    const categories = {}

    for (const [key, cat] of Object.entries(configCategories)) {
      categories[key] = {
        enabled: cat.required || false,
        readOnly: cat.required || false
      }
    }

    return categories
  }

  buildSections(config) {
    const sections = [{
      title: "Cookie usage",
      description: `For more details, see our <a href="${config.privacy_policy_url || "/privacy"}">privacy policy</a>.`
    }]

    for (const [key, cat] of Object.entries(config.categories || {})) {
      sections.push({
        title: cat.title || key,
        description: cat.description || "",
        linkedCategory: key
      })
    }

    return sections
  }

  logConsent() {
    const consent = CookieConsent.getCookie()
    const categories = {}
    const acceptedCategories = CookieConsent.getUserPreferences().acceptedCategories || []

    for (const key of Object.keys(this.configValue.categories || {})) {
      categories[key] = acceptedCategories.includes(key)
    }

    const visitorId = consent?.consentId || this.generateVisitorId()

    fetch(this.endpointValue, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": this.csrfToken
      },
      body: JSON.stringify({
        consent: {
          visitor_id: visitorId,
          categories: categories,
          policy_version: "1.0"
        }
      })
    })
  }

  generateVisitorId() {
    return `af_${Date.now()}_${Math.random().toString(36).substring(2, 9)}`
  }

  get csrfToken() {
    const meta = document.querySelector('meta[name="csrf-token"]')
    return meta ? meta.content : ""
  }
}
