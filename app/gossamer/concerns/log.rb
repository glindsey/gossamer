# frozen_string_literal: true

require 'date'

require COMMON_INCLUDES

module Gossamer
  module Concerns
    # Utility methods to provide for simple logging functionality.
    # Right now this is super-simple; it just logs to STDOUT, based on a
    # constant LOG_LEVEL value set in this mixin.
    #
    # The eventual goal would be to allow for logging to a file, or console plus
    # file, and to let the log level be set dynamically.
    module Log
      extend ActiveSupport::Concern

      LOG_LEVEL = :warning

      LOG_LEVEL_MAP = {
        fatal:   0,
        error:   1,
        warning: 2,
        info:    3,
        debug:   4,
        todo:    5
      }.freeze

      LOG_TEXT_MAP = {
        fatal:   '  FATAL',
        error:   '  ERROR',
        warning: 'WARNING',
        info:    '   NOTE',
        debug:   '  DEBUG',
        todo:    '   TODO'
      }.freeze

      def log(message, level: :info)
        return unless LOG_LEVEL_MAP[level] <= LOG_LEVEL_MAP[LOG_LEVEL]

        warn "#{datetime_header} #{LOG_TEXT_MAP[level]}: #{message}"

        LOG_LEVEL_MAP[level] >= LOG_LEVEL_MAP[:info]
      end

      def datetime_header
        "[#{DateTime.now.strftime('%Y-%m-%d %H:%M:%S')}]"
      end
    end
  end
end
