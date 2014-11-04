require "crimp/version"
require "digest"

module Crimp
  def self.signature(obj)
    Digest::MD5.hexdigest stringify(obj)
  end

  def self.stringify(obj)
    case obj
    when Array
      convert_array obj
    when Hash
      convert_hash obj
    when String
      obj
    else
      convert_other obj
    end
  end

  private

  def self.convert_array(array)
    ''.tap do |string|
      stringify_elements(array).sort!.each { |e| string << e }
    end
  end

  def self.convert_hash(hash)
    stringify hash_to_array(hash)
  end

  def self.convert_other(obj)
    "#{obj.to_s}#{obj.class.to_s}"
  end

  def self.hash_to_array(hash)
    [].tap do |a|
      hash.each { |k, v| a << "#{stringify k}=>#{stringify v}" }
    end
  end

  def self.stringify_elements(array)
    array.map! { |e| stringify(e) }
  end
end
