require 'spec_helper'

describe Crimp do
  describe '.signature' do
    context 'check MD5 consistent across versions' do
      context 'given a Hash' do
        let(:hash) do
          {
            a: 123,
            b: 1.23,
            c: 'string',
            d: :sym
          }
        end
        let(:md5) { '1dd744d51279187cc08cabe240f98be2' }

        specify { expect(subject.signature(hash)).to eq md5 }
      end

      context 'given legacy Hash' do
        let(:hash) do
          { a: { b: 'b', c: 'c' }, d: 'd' }
        end
        let(:md5) { '68d07febc4f47f56fa6ef5de063a77b1' }

        specify { expect(subject.signature(hash)).to eq md5 }
      end

      context 'given an Array' do
        let(:array) { [123, 1.23, 'string', :sym] }
        let(:md5) { 'cd29980f258eef3faceca4f4da02ec65' }

        specify { expect(subject.signature(array)).to eq md5 }
      end

      context 'given legacy Array' do
        let(:array) { [1, 2, 3, [4, [5, 6]]] }
        let(:md5) { '4dc4e1161c9315db0bc43c0201b3ec05' }

        specify { expect(subject.signature(array)).to eq md5 }
      end

      context 'given stringified hash' do
        let(:stringified_hash) {"{ a: { b: 'b', c: 'c' }, d: 'd' }"}
        let(:md5) { 'f5327912eeb41996b5aded6550d11187' }

        specify { expect(subject.signature(stringified_hash)).to eq md5 }
      end

      context 'given a string' do
        let(:string) {"do shash'owania"}
        let(:md5) { '48e380a165c417253512a904d6b5cf2b' }

        specify { expect(subject.signature(string)).to eq md5 }
      end

      context 'given a number' do
        let(:number) {1234567890}
        # RUBY 2.5.0
        # let(:md5) { 'cbabd6f8bfda13b76c0e28eb0a6f4ef1' }
        let(:md5) { '1f5c62f597aefd84d180c26e1de61021' }

        specify { expect(subject.signature(number)).to eq md5 }
      end
    end
  end
end
