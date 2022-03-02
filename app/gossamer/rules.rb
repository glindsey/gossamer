# frozen_string_literal: true

module Gossamer
  # Contains all of the world rules.
  class Rules
    attr_reader :data

    def initialize
      # Load main data
      main_data = YamlLoader.new.parse(
        File.expand_path(File.join(__dir__, '..', '..', 'data')),
        directories_become_hashkeys: true
      )

      mod_data = main_data

      ['mods', File.join('experimental', 'mods')].each do |dir|
        mod_data = YamlLoader.new.parse(
          File.expand_path(File.join(__dir__, '..', '..', dir)),
          prev: mod_data
        )
      rescue Errno::ENOENT
        # Directory doesn't exist, so ignore it and move on
      end

      @data = mod_data

      ::Gossamer::RuleCops::Root.check(@data)
    end

    # @todo Everything below this probably needs to be rewritten

    def [](key)
      recursive_get(key)
    end

    def []=(key, value)
      add({ key => value })
    end

    def add(**args)
      case args
      when Symbol
        args = { args => true }
      when String
        args = { args.to_sym => true }
      when Array
        args = Hash.new(args.map { |value| [value, true] })
      end
      @data.merge!(args)
    end

    private

    def recursive_get(key, breadcrumbs: [])
      result = @data[key]

      if result.is_a?(Symbol)
        if breadcrumbs.include?(result)
          raise "Circular implication found: #{breadcrumbs}"
        end

        recursive_get(result, breadcrumbs: breadcrumbs + [result])
      else
        result || false
      end
    end
  end
end
