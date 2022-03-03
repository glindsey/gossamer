# frozen_string_literal: true

module Gossamer
  module Concerns
    # Methods to convert symbols into Gossamer classes when needed.
    module SymbolToGossamerClass
      extend ActiveSupport::Concern

      include Concerns::Log

      def dethingify(obj)
        case obj
        when Symbol, String
          obj.to_sym
        when Class
          demodulize(obj.name.to_s).underscore.to_sym
        when Object
          demodulize(obj.class.name.to_s).underscore.to_sym
        else
          raise "Don't know how to dethingify #{obj.inspect}"
        end
      end

      def thingify(obj)
        case obj
        when Symbol, String
          "::Gossamer::World::Things::#{obj.to_s.camelize}".safe_constantize
        else
          obj
        end
      end

      def thing_traitify(obj)
        case obj
        when Symbol, String
          "::Gossamer::World::Things::Traits::#{obj.to_s.camelize}"
            .safe_constantize
        else
          obj
        end
      end
    end
  end
end
