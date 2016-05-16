class Webhooks::FacebookMessengerController < ApplicationController
  def verify
    Rails.logger.info "Got verify request"
  end

  def chat
    Rails.logger.info "Got chat request"
  end
end
