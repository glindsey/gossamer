# frozen_string_literal: true

require COMMON_REQUIRES

module Gossamer
  module Services
    # Service that handles debug logging.
    # Right now this is super-simple; it just logs to STDOUT, based on a
    # constant LOG_LEVEL value set in this mixin.
    #
    # The eventual goal would be to allow for logging to a file, or console plus
    # file, and to let the log level be set dynamically.
    class Logger
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
        return unless LOG_LEVEL_MAP[level] <= LOG_LEVEL_MAP[log_level]

        warn "#{datetime_header} #{LOG_TEXT_MAP[level]}: #{message}"

        LOG_LEVEL_MAP[level] >= LOG_LEVEL_MAP[:info]
      end

      def datetime_header
        "[#{DateTime.now.strftime('%Y-%m-%d %H:%M:%S')}]"
      end

      def log_level
        ENV['LOG_LEVEL']&.to_sym || :warning
      end

      class << self
        delegate :log, to: :instance

        def instance
          @instance ||= new
        end
      end
    end
  end
end
