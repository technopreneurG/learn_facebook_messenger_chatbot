class Webhooks::FacebookMessengerWeatherController < ApplicationController
  include Webhooks::FacebookMessengerWeatherHelper
  include Webhooks::FacebookMessengerHelper
  def initialize
        @session = Rails.application.session #todo: use real session
        @session_id = "ss-id-1"
        set_wit_client
  end

  def verify
        Rails.logger.info "Got verify request"
        if params['hub.verify_token'].present? and params['hub.verify_token']==ENV['fb_verify_token']
            render plain: params['hub.challenge']
        else
            render nothing: true
        end
  end

  def chat
        Rails.logger.info "Got chat request"
        if params['entry'].present? && params['entry'][0].present? && params['entry'][0]['messaging'].present?
            messaging_events = params['entry'][0]['messaging']
            reply="reply:"
            messaging_events.each do |e|
                if e['message'].present?
                    sender_id = e['sender']['id']
                    text = e['message']['text']
                    @session_id = sender_id #todo: use real session id instead
                    @session[@session_id] = {context: {}, sender_id: sender_id} unless @session[@session_id].present?
                    reply= wit_run_actions text
                end
            end
        end
        render nothing: true
  end
end
