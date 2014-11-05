require "crimp/version"
require "digest"

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
    array.map! { |e| stringify(e) }.sort!
  end

  def self.parse_hash(hash)
    stringify hash_to_array(hash)
  end

  def self.to_string(obj)
    "#{obj.to_s}#{obj.class.to_s}"
  end
end
