# frozen_string_literal: true

module Gossamer
  module Concerns
    # Methods to convert symbols into Gossamer classes when needed.
    module SymbolToGossamerClass
      extend ActiveSupport::Concern

      include Concerns::Log

      delegate :attributify, :materialify, :thingify, :thing_traitify,
               :traitify, :gossamerify, :degossamerify,
               to: :class

      class_methods do
        def attributify(obj)
          gossamerify(obj, 'Attributes')
        end

        def materialify(obj)
          gossamerify(obj, 'Materials')
        end

        def thingify(obj)
          gossamerify(obj, 'Things')
        end

        def thing_traitify(obj)
          gossamerify(obj, 'Things::Traits')
        end

        def traitify(obj)
          gossamerify(obj, 'Traits')
        end

        # Given a symbol, try to find a matching class within the specified
        # `prefix` category.
        def gossamerify(obj, prefix)
          case obj
          when Symbol, String
            "::Gossamer::World::#{prefix}::#{obj.to_s.camelize}"
              .safe_constantize
          else
            obj
          end
        end

        # A rather stupid method that turns the very end of a class or object
        # name into a symbol. It doesn't check to see what category the class or
        # object is (i.e. a thing, trait, etc.).
        def degossamerify(obj)
          case obj
          when Symbol, String
            obj.to_sym
          when Class
            demodulize(obj.name.to_s).underscore.to_sym
          when Object
            demodulize(obj.class.name.to_s).underscore.to_sym
          else
            raise "Don't know how to degossamerify #{obj.inspect}"
          end
        end
      end
    end
  end
end
