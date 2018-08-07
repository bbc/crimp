require 'spec_helper'

describe Crimp do
  let (:hash) { { a: { b: 'b', c: 'c' }, d: 'd' } }
  let (:hash_unordered) { { d: 'd', a: { c: 'c', b: 'b' } } }
  let (:stringified_hash) {"{ a: { b: 'b', c: 'c' }, d: 'd' }"}
  let (:array) { [1, 2, 3, [4, [5, 6]]] }
  let (:array_unordered) { [3, 2, 1, [[5, 6], 4]] }

  describe '.signature' do
    context 'given a Hash' do
      specify { expect(subject.signature(hash)).to be_a String }

      it 'returns MD5 hash of stringified Hash' do
        expect(subject.signature(hash)).to eq(Digest::MD5.hexdigest(subject.stringify(hash)))
      end

      it 'does not modify original hash' do
        original_hash = { d: 'd', a: { c: 'c', b: 'b' } }
        expected_hash = { d: 'd', a: { c: 'c', b: 'b' } }

        subject.signature(original_hash)

        expect(original_hash).to eq(expected_hash)
      end
    end

    context 'given a stringified hash' do
      it 'returns MD5 hash of stringified hash' do
        expect(subject.signature(stringified_hash)).to eq(Digest::MD5.hexdigest(subject.stringify(stringified_hash)))
      end
    end

    context 'given an Array' do
      specify { expect(subject.signature(array)).to be_a String }

      it 'returns MD5 hash of stringified Array' do
        expect(subject.signature(array)).to eq(Digest::MD5.hexdigest(subject.stringify(array)))
      end

      it 'does not modify original array' do
        original_array = [5, 4, 2, 6, [5, 7, 2]]
        expected_array = [5, 4, 2, 6, [5, 7, 2]]

        subject.signature(original_array)

        expect(original_array).to eq(expected_array)
      end
    end
  end

  describe '.stringify' do
    context 'given a Hash' do
      specify { expect(subject.stringify(hash)).to be_a String }

      it 'returns equal strings for differently ordered hashes' do
        expect(subject.stringify(hash)).to eq(subject.stringify(hash_unordered))
      end

      it 'does not modify original hash' do
        original_hash = { d: 'd', a: { c: 'c', b: 'b' } }
        expected_hash = { d: 'd', a: { c: 'c', b: 'b' } }

        subject.signature(original_hash)

        expect(original_hash).to eq(expected_hash)
      end
    end

    context 'given an Array' do
      specify { expect(subject.stringify(array)).to be_a String }

      it 'returns equal strings for differently ordered arrays' do
        expect(subject.stringify(array)).to eq(subject.stringify(array_unordered))
      end

      it 'does not modify original array' do
        original_array = [5, 4, 2, 6, [5, 7, 2]]
        expected_array = [5, 4, 2, 6, [5, 7, 2]]

        subject.signature(original_array)

        expect(original_array).to eq(expected_array)
      end
    end
  end
end
