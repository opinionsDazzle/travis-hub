require 'travis/addons/instrument'
require 'travis/addons/model'
require 'travis/addons/handlers'
require 'travis/event/subscription'

module Travis
  AdminMissing      = Class.new(StandardError)
  RepositoryMissing = Class.new(StandardError)

  module Addons
    class << self
      def setup
        Handlers.constants(false).each do |name|
          handler = Handlers.const_get(name)
          name    = name.to_s.underscore
          Event::Handler.register(name, handler)
          handler.setup if handler.respond_to?(:setup)
        end
      end
    end

    setup
  end
end