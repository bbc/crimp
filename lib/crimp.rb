# frozen_string_literal: true

require 'digest'
class Crimp
  class << self
    def signature(obj)
      Digest::MD5.hexdigest(to_s(obj))
    end

    def to_s(obj)
      to_a(obj).flatten.join
    end

    def to_a(obj)
      obj = coerce(obj)

      case obj
      when String
        [obj, 's']
      when Numeric
        [obj, 'n']
      when TrueClass, FalseClass
        [obj, 'b']
      when NilClass
        [nil, '_']
      when Enumerable
        process_collection(obj)
      else
        raise ArgumentError
      end
    end

    private

    def process_collection(obj)
      obj.sort_by { |k, _| k.to_s }.map { |i| to_a(i) }
    end

    def coerce(obj)
      obj.is_a?(Symbol) ? obj.to_s : obj
    end
  end
end
