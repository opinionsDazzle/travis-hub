require 'travis/addons/handlers/generic'
require 'travis/addons/serializer/webhook/build'

module Travis
  module Addons
    module Handlers
      class Webhook < Generic
        EVENTS = /build:(started|finished)/

        def handle?
          targets.present? && config.send_on?(:webhooks, action)
        end

        def handle
          run_task(:webhook, payload, targets: targets, token: request.token)
        end

        def targets
          @targets ||= config.values(:webhooks, :urls)
        end

        def payload
          Serializer::Webhook::Build.new(object).data
        end

        class Instrument < Addons::Instrument
          def notify_completed
            publish(:targets => handler.targets)
          end
        end
        Instrument.attach_to(self)
      end
    end
  end
end
