# frozen_string_literal: true

module Gossamer
  module World
    module Traits
      # Indicates that the instantiated objects of a class have tags that can be
      # read/written/queried. Tags are always symbols.
      #
      # Eventually this may be extended to support class-level tags, but for now
      # I don't think that's necessary.
      module HasTags
        extend ActiveSupport::Concern
        include Concerns::SymbolToGossamerClass
        using Refinements::ObjectToKeysOfHash

        def tags
          @tags ||= Set.new
        end

        def tag?(tags)
          tags.include?(tag)
        end

        def create_tags_from(options)
          return unless options.key?(:tags)

          unless options[:tags].is_a?(Array)
            raise 'options[:tags] must be an Array'
          end

          tags.merge(options[:tags])
        end
      end
    end
  end
end
