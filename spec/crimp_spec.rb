require 'spec_helper'

describe '.signature' do
  it 'will return an md5 hash' do
    expect(Crimp.signature('a')).to eq 'f970e2767d0cfe75876ea857f92e319b'
  end
end

describe '.to_a' do
  it 'returns an array of tuples representing the value and the type' do
    expect(Crimp.to_a([123, 'abc'])).to eq([[123, 'n'], ['abc', 's']])
  end

  it "returns a tuple [val, 'n'] for numeric primitives" do
    expect(Crimp.to_a(123)).to eq([123, 'n'])
  end

  it "returns a tuple [val, 's'] for string primitives" do
    expect(Crimp.to_a('abc')).to eq(['abc', 's'])
  end
end

describe '.to_s' do
  it 'returns a string representation of the passed data' do
    expect(Crimp.to_s([123, 'abc'])).to eq('123nabcs')
  end
end

describe 'Strings' do
  it 'handles strings' do
    expect(Crimp.to_a('a')).to eq(['a', 's'])
  end

  it 'handles capitalised strings with no modifications' do
    expect(Crimp.to_a('A')).to eq(['A', 's'])
  end

  it 'handles utf-8 strings' do
    expect(Crimp.to_a('å')).to eq(['å', 's'])
  end

  it 'treats symbols like strings' do
    expect(Crimp.to_a(:a)).to eq(['a', 's'])
  end

  it 'treats empty strings like strings' do
    expect(Crimp.to_a('')).to eq(['', 's'])
  end
end

describe 'Numbers' do
  it 'handles integers' do
    expect(Crimp.to_a(1)).to eq([1, 'n'])
  end

  it 'handles floats' do
    expect(Crimp.to_a(3.14)).to eq([3.14, 'n'])
  end

  it 'handles bignums' do
    bignum = 10_000_000_000_000_000_000

    expect(Crimp.to_a(bignum)).to eq([bignum, 'n'])
  end
end

describe 'Nils' do
  it 'handles nils' do
    expect(Crimp.to_a(nil)).to eq([nil, '_'])
  end
end

describe 'Booleans' do
  it 'handles falsey values' do
    expect(Crimp.to_a(false)).to eq([false, 'b'])
  end

  it 'handles thruty values' do
    expect(Crimp.to_a(true)).to eq([true, 'b'])
  end
end

describe 'Arrays' do
  it 'handles arrays as collection of primitives' do
    expect(Crimp.to_a([1, 2])).to eq([[1, 'n'],[2, 'n']])
  end

  it 'sorts arrays' do
    expect(Crimp.to_a([2, 1])).to eq([[1, 'n'],[2, 'n']])
  end

  it 'returns the same signature for two arrays containing the same (unordered) values' do
    arr1 = [1, 2, 3]
    arr2 = [2, 1, 3]

    expect(Crimp.signature(arr1)).to eq(Crimp.signature(arr2))
  end

  it 'does not return the same signature for two arrays containing different values' do
    arr1 = [1, 2, 3]
    arr2 = ['1', '2', '3']

    expect(Crimp.signature(arr1)).to_not eq(Crimp.signature(arr2))
  end
end

describe 'Hashes' do
  it 'handles hashes as collection of primitives' do
    expect(Crimp.to_a({a: 'b'})).to eq([[['a', 's'],['b', 's']]])
  end

  it 'sorts hashes by key and then sorts the resulting pair of tuples' do
    expected = [
      [
        ['a', 's'],
        ['b', 's']
      ],
      [
        [1,   'n'],
        ['e', 's']
      ],
      [
        ['c', 's'],
        ['f', 's']
      ]
    ]

    expect(Crimp.to_a({a: 'b', f: 'c', 'e' => 1})).to eq(expected)
  end

  it 'returns the same signature for two hashes containing the same (unordered) values' do
    hsh1 = { a: 2, b: 1}
    hsh2 = { b: 1, a: 2}

    expect(Crimp.signature(hsh1)).to eq(Crimp.signature(hsh2))
  end

  it 'does not return the same signature for two hashes containing the different values' do
    hsh1 = { a: 1, b: 2}
    hsh2 = { a: 2, b: 1}

    expect(Crimp.signature(hsh1)).to_not eq(Crimp.signature(hsh2))
  end
end

describe 'Sets' do
  it 'handles sets' do
    expect(Crimp.to_a(Set.new([1, 2]))).to eq([[1, 'n'],[2, 'n']])
  end

  it 'sorts sets' do
    expect(Crimp.to_a(Set.new([2, 1]))).to eq([[1, 'n'],[2, 'n']])
  end
end

describe 'nested data structures' do
  it 'handles an hash with nested arrays' do
    obj = { a: [1, 2], b: { c: 'd' } }

    expected = [
      [
        [
          [1, 'n'],
          [2, 'n']
        ],
        ['a', 's']
      ],
      [
        ['b', 's'],
        [
          [
            ['c', 's'],
            ['d', 's']
          ]
        ]
      ]
    ]

    expect(Crimp.to_a(obj)).to eq(expected)
  end

  it 'handles an array of hashes' do
    obj = [{ a: 1 }, { b: 2 }]

    expected = [
      [
        [
          [1, 'n'],
          ['a', 's']
        ]
      ],
      [
        [
          [2, 'n'],
          ['b', 's']
        ]
      ]
    ]

    expect(Crimp.to_a(obj)).to eq(expected)
  end
end

describe 'Objects' do
  it 'raise an error if not in the list of allowed primitives' do
    expect { Crimp.signature(Object.new) }.to raise_error(ArgumentError)
  end
end
