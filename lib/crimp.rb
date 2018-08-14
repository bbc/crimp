# frozen_string_literal: true

require 'digest/md5'

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
        [obj, 'S']
      when Numeric
        [obj, 'N']
      when TrueClass, FalseClass
        [obj, 'B']
      when NilClass
        [nil, '_']
      when Enumerable
        process_collection(obj)
      else
        raise TypeError, "Expected a (String|Number|Boolean|Nil|Hash|Array|Set), Got #{obj.class}."
      end
    end

    private

    def process_collection(coll)
      [
        coll.sort_by { |k, _| k.to_s }.map { |obj| to_a(obj) },
        coll.class.to_s[0]
      ]
    end

    def coerce(obj)
      obj.is_a?(Symbol) ? obj.to_s : obj
    end
  end
end
