# frozen_string_literal: true

require 'date'

require COMMON_REQUIRES

module Gossamer
  module Concerns
    # Utility concern to delegate logging to the Logger service.
    module Log
      extend ActiveSupport::Concern

      def log(message, level: :info)
        ::Gossamer::Services::Logger.log(message, level:)
      end

      def self.log(message, level: :info)
        ::Gossamer::Services::Logger.log(message, level:)
      end
    end
  end
end
