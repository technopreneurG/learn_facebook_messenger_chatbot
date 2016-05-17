class Webhooks::FacebookMessengerController < ApplicationController
    include Webhooks::FacebookMessengerHelper

    def verify
        Rails.logger.info "Got verify request"
        if params['hub.verify_token'].present? and params['hub.verify_token']==ENV['fb_verify_token']
            render plain: params['hub.challenge'];
        else
            render nothing: true
        end
    end

    def chat
        Rails.logger.info "Got chat request"
        messaging_events = params['entry'][0]['messaging']
        if messaging_events.present?
            messaging_events.each do |e|
                if e['message'].present?
                    sender_id = e['sender']['id']
                    text = e['message']['text']
                    send_text_message(sender_id, "got : #{text}")
                end
            end
        end
        render nothing: true
    end
end
