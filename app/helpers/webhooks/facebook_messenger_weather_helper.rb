require 'wit'
module Webhooks::FacebookMessengerWeatherHelper
    def set_wit_client
        access_token=ENV['fb_access_token']
        actions = {
            send: -> (message, response) {
                new_context=parse_entities(message['context'], message['entities'])
                send_message_text message['session_id'], response['text']
                new_context

            },
            test: -> (message) {
                new_context=parse_entities(message['context'], message['entities'])
                new_context
            }
        @client = Wit.new(access_token: access_token, actions: actions)

    def resolve_entity(entity)
        if entity.present? && entity[0].present? && entity[0]['confidence'].to_f > 0.99
            return entity[0]['value']
        end
    end

    def parse_entities(context, entities)
        return context unless entities.present?

        new_context=context.clone

        #clean up
        new_context.delete('missingIntent')
        new_context.delete('missingDatetime')
        new_context.delete('missingLocation')

        if entities['intent'].present?
            new_context['intent'] = entities['intent']
        end
        if entities['datetime'].present?
            new_context['datetime'] = entities['datetime']
        end
        if entities['location'].present?
            new_context['location'] = entities['location']
        end

        #re-verify
        new_context['missingIntent'] = true unless new_context['intent'].present?
        new_context['missingDatetime'] = true unless new_context['datetime'].present?
        new_context['missingLocation'] = true unless new_context['location'].present?
        return new_context
    end

    def wit_run_actions(message)
        ctxt1=@client.run_actions(@session_id, message, @session[@session_id][:context])
        @session[@session_id][:context] = ctxt1
    end

    def wit_message(message)
        resp = @client.message message
        Rails.logger.info "Yay, got Wit.ai response: #{resp}"
        if resp['entities'].present?
            if resp['entities']['intent'].present?
                resp['entities']['intent'].each do |i|
                    if i['value'] == 'greeting'
                        return "hello"
                    end
                end
            end
        end
    end
end
