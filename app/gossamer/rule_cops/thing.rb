# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for a single thing.
    class Thing < Base
      def initialize(full_data, path: [])
        super
      end

      def _check
        check_subkeys do |key, value|
          subpath = path + [key]
          case key
          when 'abstract!'
            ::Gossamer::RuleCops::BooleanData.check(
              full_data, path: subpath
            )
          # `part_property!` indicates that parts of this thing will inherit
          # this thing as a property. For example, "human" has `part_property!`
          # set, because its parts should be considered a "human head", a
          # "human leg", et cetera.
          when 'part_property!'
            log = ::Gossamer::RuleCops::BooleanData.check(
              full_data, path: subpath
            )

            # @todo It might be better to just auto-add things with this meta-
            #       property set as properties in their own right, instead of
            #       requiring them to be declared in the ruleset.
            if value == true && !full_data['properties'].key?(value)
              log += uhoh(
                "`part_property!` is true, but '#{path[-1]}' is not defined " \
                'as a property in the ruleset'
              )
            end

            log
          when 'always'
            ::Gossamer::RuleCops::Always.check(
              full_data, path: subpath
            )
          when 'has_parts', 'has_properties'
            uhoh("#{key} must be under 'always' or 'usually'")
          when 'is_a_kind_of'
            ::Gossamer::RuleCops::ConceptReference.check(
              full_data, category: 'things', path: subpath
            )
          when 'usually'
            ::Gossamer::RuleCops::Usually.check(
              full_data, path: subpath
            )
          else
            unknown(key)
          end
        end
      end
    end
  end
end
