# frozen_string_literal: true

require 'digest/md5'
require 'set'
require 'deepsort'

class Crimp
  class << self
    def signature(obj)
      Digest::MD5.hexdigest(notation(obj))
    end

    def notation(obj)
      reduce(obj).flatten.join
    end

    def reduce(obj)
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
        [sort(obj), 'A']
      when Hash
        [sort(obj), 'H']
      else
        raise TypeError, "Expected a (String|Number|Boolean|Nil|Hash|Array), Got #{obj.class}."
      end
    end

    private

    def sort(coll)
      coll.deep_sort_by { |obj| obj.to_s }.map { |obj| reduce(obj) }
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
