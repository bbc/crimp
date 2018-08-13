require 'spec_helper'

describe Crimp do
  let(:hash) { { a: { b: 'b', c: 'c' }, d: 'd' } }
  let(:hash_with_numbers) { { a: { b: 1, c: 3.14 }, d: 'd' } }
  let(:hash_unordered) { { d: 'd', a: { c: 'c', b: 'b' } } }
  let(:array) { [1, 2, 3, [4, [5, 6]]] }
  let(:array_unordered) { [3, 2, 1, [[5, 6], 4]] }

  describe '.signature' do
    context 'given a Hash' do
      it 'returns MD5 hash of stringified Hash' do
        expect(subject.signature(hash)).to eq('68d07febc4f47f56fa6ef5de063a77b1')
      end

      it 'does not modify original hash' do
        original_hash = { d: 'd', a: { c: 'c', b: 'b' } }
        expected_hash = { d: 'd', a: { c: 'c', b: 'b' } }

        subject.signature(original_hash)

        expect(original_hash).to eq(expected_hash)
      end
    end

    context 'Given an hash with numbers' do
      it 'returns MD5 hash of stringified hash' do
        expect(subject.signature(hash_with_numbers)).to eq 'b1fec09904b6ff36c92e3bd48234def7'
      end
    end

    context 'given an Array' do
      it 'returns MD5 hash of stringified Array' do
        expect(subject.signature(array)).to eq('4dc4e1161c9315db0bc43c0201b3ec05')
      end

      it 'does not modify original array' do
        original_array = [5, 4, 2, 6, [5, 7, 2]]
        expected_array = [5, 4, 2, 6, [5, 7, 2]]

        subject.signature(original_array)

        expect(original_array).to eq(expected_array)
      end
    end

    context 'Given an integer' do
      it 'returns MD5 hash of an Integer' do
        expect(subject.signature(123)).to eq '519d3381631851be66711f6d7dfbb4f8'
      end
    end

    context 'Given an Bignum' do
      it 'returns MD5 hash of a Bignum' do
        expect(subject.signature(9999999999999999999)).to eq 'f00e75abca720e18fd4213e2a6de96c6'
      end
    end

    context 'Given an float' do
      it 'returns MD5 hash of a Float' do
        expect(subject.signature(3.14)).to eq 'b07d506e3701fddd083ae9095df43218'
      end
    end
  end

  describe '.stringify' do
    context 'given a Hash' do
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
