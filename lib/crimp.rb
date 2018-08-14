# frozen_string_literal: true

require 'digest/md5'
require 'set'

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
      when Array
        [reduce(obj), 'A']
      when Hash
        [reduce(obj), 'H']
      else
        raise TypeError, "Expected a (String|Number|Boolean|Nil|Hash|Array), Got #{obj.class}."
      end
    end

    private

    def reduce(coll)
      coll.sort_by { |k, _| k.to_s }.map { |obj| to_a(obj) }
    end

    def coerce(obj)
      case obj
      when Symbol then obj.to_s
      when Set    then obj.to_a
      else obj
      end
    end
  end
end
