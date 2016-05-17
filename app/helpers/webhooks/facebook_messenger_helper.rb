module Webhooks::FacebookMessengerHelper
    def send_text_message(to, text)
        begin
            body={
                recipient: {id: to},
                message: {text: text}
            }
            url='https://graph.facebook.com/v2.6/me/messages?access_token='+ENV['fb_access_token']

            uri = URI.parse(url)
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE

            request = Net::HTTP::Post.new(uri.request_uri)
            request.content_type = 'application/json'
            request.body = body.to_json

            response = http.request(request)
            Rails.logger.info response.body
        rescue => e #todo: instead handle error response codes
            puts "Error: #{e.message}"
        end
    end
end
