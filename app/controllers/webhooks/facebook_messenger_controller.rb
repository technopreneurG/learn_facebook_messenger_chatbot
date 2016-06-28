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
        if params['entry'].present? && params['entry'][0].present? && params['entry'][0]['messaging'].present?
            messaging_events = params['entry'][0]['messaging']
            messaging_events.each do |e|
                if e['message'].present?
                    sender_id = e['sender']['id']
                    text = e['message']['text']
                    if text.starts_with? "t:"
                        send_message_text(sender_id, "got: #{text}")
                    elsif text.starts_with? "g:"
                        message=[
                            {
                                title: "Classic White T-Shirt",
                                image_url: "http://petersapparel.parseapp.com/img/item100-thumb.png",
                                subtitle: "Soft white cotton t-shirt is back in style",
                                buttons: [
                                    {
                                        type: "web_url",
                                        url: "https://petersapparel.parseapp.com/view_item?item_id=100",
                                        title: "View Item"
                                    },
                                    {
                                        type: "web_url",
                                        url: "https://petersapparel.parseapp.com/buy_item?item_id=100",
                                        title: "Buy Item"
                                    },
                                    {
                                        type: "postback",
                                        title: "Bookmark Item",
                                        payload: "USER_DEFINED_PAYLOAD_FOR_ITEM100"
                                    }
                                ]
                            },
                            {
                                title: "Classic Grey T-Shirt",
                                image_url: "http://petersapparel.parseapp.com/img/item101-thumb.png",
                                subtitle: "Soft gray cotton t-shirt is back in style",
                                buttons: [
                                    {
                                        type: "web_url",
                                        url: "https://petersapparel.parseapp.com/view_item?item_id=101",
                                        title: "View Item"
                                    },
                                    {
                                        type: "web_url",
                                        url: "https://petersapparel.parseapp.com/buy_item?item_id=101",
                                        title: "Buy Item"
                                    },
                                    {
                                        type: "postback",
                                        title: "Bookmark Item",
                                        payload: "USER_DEFINED_PAYLOAD_FOR_ITEM101"
                                    }
                                ]
                            }
                        ]
                        send_template_message_generic(sender_id, message)
                    elsif text.starts_with? "b:"
                        message={
                            text: "What do you want to do next?",
                            buttons: [
                                {
                                    type: "web_url",
                                    url: "https://petersapparel.parseapp.com",
                                    title: "Show Website"
                                },
                                {
                                    type: "postback",
                                    title: "Start Chatting",
                                    payload: "USER_DEFINED_PAYLOAD"
                                }
                            ]
                        }
                        send_template_message_button(sender_id, message)
                    else
                        #we don't understand this message, tell user how to interact
                        send_message_text(sender_id, "We didn't understand your message, message should start with t:,g: OR b: for text, generic template OR button template respectively")
                    end
                end
            end
        end
        render nothing: true
    end
end
