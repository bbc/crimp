require 'crimp/version'
require 'digest'

module Crimp
  def self.signature(obj)
    Digest::MD5.hexdigest stringify(obj)
  end

  def self.stringify(obj)
    convert(obj).tap { |o| return o.class == String ? o : to_string(o) }
  end

  private

  def self.convert(obj)
    case obj
    when Array
      parse_array obj
    when Hash
      parse_hash obj
    when String
      obj
    when Integer
      integer_to_string obj
    else
      to_string obj
    end
  end

  def self.hash_to_array(hash)
    [].tap do |a|
      hash.each { |k, v| a << pair_to_string(k, v) }
    end
  end

  def self.pair_to_string(k, v)
    "#{stringify k}=>#{stringify v}"
  end

  def self.parse_array(array)
    array.map { |e| stringify(e) }.sort
  end

  def self.parse_hash(hash)
    stringify hash_to_array(hash)
  end

  def self.to_string(obj)
    "#{obj}#{obj.class}"
  end

  # This is for legacy/compatibilty reason:
  #
  # Ruby 2.1
  # 2.class => Fixnum
  # Ruby > 2.4
  # 2.class => Integer
  #
  # Say you have a huge number of stored keys and you migrate your app from 2.1 to >= 2.4
  # this would cause a change of the signature for a subset of the keys which would be hard
  # to debug especially for nested data structures.
  #
  def self.integer_to_string(obj)
    "#{obj}Fixnum"
  end
end
