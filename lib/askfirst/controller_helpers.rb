module AskFirst
  module ControllerHelpers
    def consent_given?(category)
      consent = request.env["askfirst.consent"] || {}
      consent[category.to_s] == true
    end
  end
end
