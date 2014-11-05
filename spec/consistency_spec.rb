require 'spec_helper'

describe Crimp do
  describe '.signature' do
    context 'check MD5 consistent across versions' do
      context 'given a Hash' do
        let(:hash) do
          {
            :a => 123,
            :b => 1.23,
            :c => 'string',
            :d => :sym
          }
        end
        let(:md5) { '1dd744d51279187cc08cabe240f98be2' }

        specify { expect(subject.signature hash).to eq md5 }
      end

      context 'given legacy Hash' do
        let(:hash) do
          {:a => {:b => 'b', :c => 'c'}, :d => 'd'}
        end
        let(:md5) { '68d07febc4f47f56fa6ef5de063a77b1' }

        specify { expect(subject.signature hash).to eq md5 }
      end

      context 'given an Array' do
        let(:array) { [123, 1.23, 'string', :sym] }
        let(:md5) { 'cd29980f258eef3faceca4f4da02ec65' }

        specify { expect(subject.signature array).to eq md5 }
      end

      context 'given legacy Array' do
        let(:array) { [1, 2, 3, [4, [5, 6]]] }
        let(:md5) { '4dc4e1161c9315db0bc43c0201b3ec05' }

        specify { expect(subject.signature array).to eq md5 }
      end
    end
  end
end
