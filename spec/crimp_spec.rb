require 'spec_helper'

describe Crimp do
  let (:hash) { {:a => {:b => 'b', :c => 'c'}, :d => 'd'} }
  let (:hash_unordered) { {:d => 'd', :a => {:c => 'c', :b => 'b'}} }
  let (:array) { [1, 2, 3, [4, [5, 6]]] }
  let (:array_unordered) { [3, 2, 1, [[5, 6], 4]] }

  describe ".signature" do
    context "given a Hash" do
      specify { expect(subject.signature hash).to be_a String }

      it "returns MD5 hash of stringified Hash" do
        expect(
          subject.signature(hash)
        ).to eq(
          Digest::MD5.hexdigest(subject.stringify(hash))
        )
      end

      context 'check MD5 consistent across versions' do
        let(:expected_md5) { '68d07febc4f47f56fa6ef5de063a77b1' }
        specify { expect(subject.signature hash).to eq expected_md5 }
      end
    end

    context "given an Array" do
      specify { expect(subject.signature array).to be_a String }

      it "returns MD5 hash of stringified Array" do
        expect(
          subject.signature(array)
        ).to eq(
          Digest::MD5.hexdigest(subject.stringify(array))
        )
      end

      context 'check MD5 consistent across versions' do
        let(:expected_md5) { '4dc4e1161c9315db0bc43c0201b3ec05' }
        specify { expect(subject.signature array).to eq expected_md5 }
      end
    end

  end

  describe ".stringify" do
    context "given a Hash" do
      specify { expect(subject.stringify hash).to be_a String }

      it "returns equal strings for differently ordered hashes" do
        expect(
          subject.stringify(hash)
        ).to eq(
          subject.stringify(hash_unordered)
        )
      end
    end

    context "given an Array" do
      specify { expect(subject.stringify array).to be_a String }

      it "returns equal strings for differently ordered arrays" do
        expect(
          subject.stringify(array)
        ).to eq(
          subject.stringify(array_unordered)
        )
      end
    end
  end
end
