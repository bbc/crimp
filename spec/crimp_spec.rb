require 'spec_helper'

describe Crimp do
  let (:example_hash) { {:a => {:b => 'b', :c => 'c'}, :d => 'd'} }
  let (:example_hash_unordered) { {:d => 'd', :a => {:c => 'c', :b => 'b'}} }
  let (:example_array) { [1,2,3,[4,[5,6]]] }
  let (:example_array_unordered) { [3,2,1,[[5,6],4]] }

  describe ".signature(obj)" do
    context "obj.class == Hash" do
      it "returns a string" do
        expect(subject.signature(example_hash)).to be_a String
      end

      it "returns Digest::MD5.hexdigest of self.stringify(obj)" do
        expect(
          subject.signature(example_hash)
        ).to eq(
          Digest::MD5.hexdigest(subject.stringify(example_hash))
        )
      end
    end

    context "obj.class == Array" do
      it "returns a string" do
        expect(subject.signature(example_array)).to be_a String
      end

      it "returns Digest::MD5.hexdigest of self.stringify(obj)" do
        expect(
          subject.signature(example_array)
        ).to eq(
          Digest::MD5.hexdigest(subject.stringify(example_array))
        )
      end
    end

  end

  describe ".stringify(obj)" do
    context "obj.class == Hash" do
      it "returns a string" do
        expect(subject.stringify(example_hash)).to be_a String
      end

      it "will return equal strings for differently ordered hashes" do
        expect(
          subject.stringify(example_hash)
        ).to eq(
        subject.stringify(example_hash_unordered)
        )
      end
    end

    context "obj.class == Array" do
      it "returns a string" do
        expect(subject.stringify(example_array)).to be_a String
      end

      it "will return equal strings for differently ordered arrays" do
        expect(
          subject.stringify(example_array)
        ).to eq(
        subject.stringify(example_array_unordered)
        )
      end

    end
  end
end
