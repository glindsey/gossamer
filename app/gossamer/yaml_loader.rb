# frozen_string_literal: true

require 'active_support/core_ext/hash/deep_merge'
require 'active_support/core_ext/object/blank'
require 'psych'
require_relative '../gossamer'

module Gossamer
  # Utility methods that load YAML files from a directory and return the
  # resulting hash.
  class YamlLoader
    include Gossamer::Mixins::SmartMerge

    # The top-level "parse" command.
    # @param path   A string containing the "root" data directory name.
    # @param file   A string containing the name of the entry to parse, or blank
    #               to parse all entries in the directory.
    # @return       A `Hash` containing the data read.
    def parse(path, file = '')
      raise 'Path must be a String' unless path.is_a?(String)

      full_path = file.present? ? File.join(path, file) : path
      warn "Parsing #{full_path}"

      if File.directory?(full_path)
        file.present? ? { file => parse_dir(full_path) } : parse_dir(full_path)
      else
        Psych.safe_load(File.read(full_path))
      end
    end

    private

    def parse_dir(path)
      data = {}

      Dir.new(path).each_child do |child|
        child_data = parse(path, child)
        data = smart_merge(data, child_data)
      end

      data
    end
  end
end
