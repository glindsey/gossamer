# frozen_string_literal: true

require COMMON_INCLUDES

module Gossamer
  # Utility methods that load YAML files from a directory and return the
  # resulting hash.
  #
  # It's important to note that for the purposes of this loader, any arrays in
  # YAML files are treated as *sets*, not lists. This means that if two arrays
  # nested under hashes with identical keys are merged, the result will be the
  # *union* of the two arrays, and not a concatenation of them.
  class YamlLoader
    include Gossamer::Mixins::SmartMerge

    # The top-level "parse" command.
    # @param path   A string containing the "root" data directory name.
    # @param file   A string containing the name of the entry to parse, or blank
    #               to parse all entries in the directory.
    # @param prev   Previous data to merge this data into, if any.
    # @return       A `Hash` containing the data read.
    #
    # Options:
    #   directories_become_hashkeys - If true, subdirectories under the path
    #                                 are treated as hash keys, with their
    #                                 contents as the corresponding values.
    #                                 This method is used for the native "data"
    #                                 directory, but not for mod directories
    #                                 since people might want to organize mods
    #                                 in whatever way they see fit.
    def parse(path, file: '', prev: {}, **options)
      raise 'Path must be a String' unless path.is_a?(String)

      full_path = file.present? ? File.join(path, file) : path
      warn "Parsing #{full_path}"

      data =
        if File.directory?(full_path)
          if file.present? && options[:directories_become_hashkeys]
            { file => parse_dir(full_path, **options) }
          else
            parse_dir(full_path, **options)
          end
        else
          Psych.safe_load(File.read(full_path))
        end

      smart_merge(prev, data, strict: true)
    end

    private

    def parse_dir(path, **options)
      data = {}

      Dir.new(path).each_child do |child|
        child_data = parse(path, file: child, **options)
        data = smart_merge(data, child_data)
      end

      data
    end
  end
end
