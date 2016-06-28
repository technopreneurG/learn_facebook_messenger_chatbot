module Webhooks::FacebookMessengerHelper
    def send_message(body)
        begin
            url='https://graph.facebook.com/v2.6/me/messages?access_token='+ENV['fb_access_token']

            uri = URI.parse(url)
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE

            request = Net::HTTP::Post.new(uri.request_uri)
            request.content_type = 'application/json'
            request.body = body.to_json

            Rails.logger.debug request.body
            response = http.request(request)
            Rails.logger.debug response.body
        rescue => e #todo: instead handle error response codes
            Rails.logger.warn "Error: #{e.message}"
            Rails.logger.warn e.backtrace
        end
    end

    def send_message_text(to, text)
        body={
            recipient: {id: to},
            message: {text: text}
        }
        send_message(body)
    end

    def send_template_message_generic(to, message)
        body={
            recipient: {id: to},
            message: {
                attachment: {
                    type:"template",
                    payload: {
                        template_type:"generic",
                        elements: message
                    }
                }
            }
        }
        send_message(body)
    end

    def send_template_message_button(to, message)
        body={
            recipient: {id: to},
            message: {
                attachment: {
                    type:"template",
                    payload: {
                        template_type:"button",
                        text: message[:text],
                        buttons: message[:buttons]
                    }
                }
            }
        }
        send_message(body)
    end
end
