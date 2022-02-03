# frozen_string_literal: true

module Gossamer
  # Contains all of the world rules.
  class Rules
    attr_reader :data

    def initialize
      # Load main data
      main_data = YamlLoader.new.parse(
        File.expand_path(File.join(__dir__, '..', '..', 'data'))
      )

      # Load mod data
      @data = YamlLoader.new.parse(
        File.expand_path(File.join(__dir__, '..', '..', 'mods')),
        prev: main_data
      )

      warn ::Gossamer::RuleCops::Root.new(@data).check
    end

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
