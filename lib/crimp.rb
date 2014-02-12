require "crimp/version"
require "digest"

module Crimp
  def self.stringify(obj)
    if obj.class == Hash
      arr = []
      obj.each do |key, value|
        arr << "#{self.stringify key}=>#{self.stringify value}"
      end
      obj = arr
    end
    if obj.class == Array
      str = ''
      obj.map! do |value|
        self.stringify value
      end.sort!.each do |value|
        str << value
      end
    end
    if obj.class != String
      obj = obj.to_s << obj.class.to_s
    end
    obj
  end

  def self.signature(obj)
    Digest::MD5.hexdigest( self.stringify obj )
  end
end
