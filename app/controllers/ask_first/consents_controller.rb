module AskFirst
  class ConsentsController < ActionController::Base
    skip_forgery_protection

    def create
      record = ConsentRecord.new(consent_params)
      record.ip_address = request.remote_ip
      record.user_agent = request.user_agent

      if record.save
        head :created
      else
        head :unprocessable_entity
      end
    end

    private

    def consent_params
      params.require(:consent).permit(:visitor_id, :policy_version, categories: {})
    end
  end
end
