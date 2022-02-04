# frozen_string_literal: true

module Gossamer
  module RuleCops
    # Sanity checker for a single thing.
    class Thing < Base
      include Gossamer::Mixins::Log

      def initialize(full_data, path: [])
        super
      end

      def _check
        # Process inheritance first.
        # @todo Maybe also do `is_a_kind_of` here too? Unsure.
        process_inheritance if data.key?('inherits_from')

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
            ::Gossamer::RuleCops::BooleanData.check(
              full_data, path: subpath
            )

            # @todo It might be better to just auto-add things with this meta-
            #       property set as properties in their own right, instead of
            #       requiring them to be declared in the ruleset.
            #
            #       Also, this isn't checked for an abstract thing, because it
            #       should apply to subclass things, not the abstract thing.
            if value == true && !data.key?('abstract!') &&
               !full_data['properties'].key?(value)
              check_log("`part_property!` is true, but '#{path[-1]}' is not " \
                        'defined as a property in the ruleset',
                        level: :warning)
            end
          when 'always'
            ::Gossamer::RuleCops::Always.check(
              full_data, path: subpath
            )
          when 'has_parts', 'has_properties'
            check_log("#{key} must be under 'always' or 'usually'",
                      level: :warning)
          when 'inherits_from', 'is_a_kind_of'
            # No problem, this was already handled above
          when 'usually'
            ::Gossamer::RuleCops::Usually.check(
              full_data, path: subpath
            )
          else
            log_unknown(key)
          end
        end
      end
    end
  end
end
