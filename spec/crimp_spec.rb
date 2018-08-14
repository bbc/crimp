# frozen_string_literal: true

require 'spec_helper'

describe '.signature' do
  it 'will return an md5 hash' do
    expect(Crimp.signature('a')).to eq 'd132c0567a5964930f9ee5f14e779e32'
  end
end

describe '.to_a' do
  it 'returns an array of tuples representing the value and the type' do
    expect(Crimp.to_a([123, 'abc'])).to eq([[[123, 'N'], ['abc', 'S']], 'A'])
  end

  it "returns a tuple [val, 'N'] for numeric primitives" do
    expect(Crimp.to_a(123)).to eq([123, 'N'])
  end

  it "returns a tuple [val, 'S'] for string primitives" do
    expect(Crimp.to_a('abc')).to eq(['abc', 'S'])
  end

  it "returns a tuple [[], 'A'] for empty arrays" do
    expect(Crimp.to_a([])).to eq([[], 'A'])
  end
end

describe '.to_s' do
  it 'returns a string representation of the passed data' do
    expect(Crimp.to_s([123, 'abc'])).to eq('123NabcSA')
  end
end

describe 'Strings' do
  it 'handles strings' do
    expect(Crimp.to_a('a')).to eq(['a', 'S'])
  end

  it 'handles capitalised strings with no modifications' do
    expect(Crimp.to_a('A')).to eq(['A', 'S'])
  end

  it 'handles utf-8 strings' do
    expect(Crimp.to_a('å')).to eq(['å', 'S'])
  end

  it 'treats symbols like strings' do
    expect(Crimp.to_a(:a)).to eq(['a', 'S'])
  end

  it 'treats empty strings like strings' do
    expect(Crimp.to_a('')).to eq(['', 'S'])
  end
end

describe 'Numbers' do
  it 'handles integers' do
    expect(Crimp.to_a(1)).to eq([1, 'N'])
  end

  it 'handles floats' do
    expect(Crimp.to_a(3.14)).to eq([3.14, 'N'])
  end

  it 'handles bignums' do
    bignum = 10_000_000_000_000_000_000

    expect(Crimp.to_a(bignum)).to eq([bignum, 'N'])
  end
end

describe 'Nils' do
  it 'handles nils' do
    expect(Crimp.to_a(nil)).to eq([nil, '_'])
  end
end

describe 'Booleans' do
  it 'handles falsey values' do
    expect(Crimp.to_a(false)).to eq([false, 'B'])
  end

  it 'handles thruty values' do
    expect(Crimp.to_a(true)).to eq([true, 'B'])
  end
end

describe 'Arrays' do
  it 'handles arrays as collection of primitives' do
    expect(Crimp.to_a([1, 2])).to eq([[[1, 'N'], [2, 'N']], 'A'])
  end

  it 'sorts arrays' do
    expect(Crimp.to_a([2, 1])).to eq([[[1, 'N'], [2, 'N']], 'A'])
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
    expected = [
      [
        [
          [
            ['a', 'S'],
            ['b', 'S']
          ],
          'A'
        ]
      ],
      'H'
    ]

    expect(Crimp.to_a({a: 'b'})).to eq(expected)
  end

  it 'sorts hashes by key and then sorts the resulting pair of tuples' do
    expected = [
      [
        [
          [
            ['a', 'S'],
            ['b', 'S']
          ],
          'A'
        ],
        [
          [
            [1, 'N'],
            ['e', 'S']
          ],
          'A'
        ],
        [
          [
            ['c', 'S'],
            ['f', 'S']
          ],
          'A'
        ]
      ],
      'H'
    ]

    expect(Crimp.to_a({ a: 'b', f: 'c', 'e' => 1 })).to eq(expected)
  end

  it 'returns the same signature for two hashes containing the same (unordered) values' do
    hsh1 = { a: 2, b: 1 }
    hsh2 = { b: 1, a: 2 }

    expect(Crimp.signature(hsh1)).to eq(Crimp.signature(hsh2))
  end

  it 'does not return the same signature for two hashes containing the different values' do
    hsh1 = { a: 1, b: 2 }
    hsh2 = { a: 2, b: 1 }

    expect(Crimp.signature(hsh1)).to_not eq(Crimp.signature(hsh2))
  end
end

describe 'Sets' do
  it 'handles sets as arrays' do
    expect(Crimp.to_a(Set.new([1, 2]))).to eq([[[1, 'N'], [2, 'N']], 'A'])
  end

  it 'sorts sets as arrays' do
    expect(Crimp.to_a(Set.new([2, 1]))).to eq([[[1, 'N'], [2, 'N']], 'A'])
  end
end

describe 'nested data structures' do
  it 'handles an hash with nested arrays' do
    obj = { a: [1, 2], b: { c: 'd' } }

    expected = [
      [
        [
          [
            [
              [
                [1, 'N'],
                [2, 'N']
              ],
              'A'
            ],
            ['a', 'S']
          ],
          'A'
        ],
        [
          [
            ['b', 'S'],
            [
              [
                [
                  [
                    ['c', 'S'],
                    ['d', 'S']
                  ],
                  'A']
              ],
              'H']
          ],
          'A']
      ],
      'H'
    ]

    expect(Crimp.to_a(obj)).to eq(expected)
  end

  it 'handles an array of hashes' do
    obj = [{ a: 1 }, { b: 2 }]
    expected= [
      [
        [
          [
            [
              [
                [1, 'N'],
                ['a', 'S']
              ],
              'A'
            ]
          ],
          'H'
        ],
        [
          [
            [
              [
                [2, 'N'],
                ['b', 'S']
              ],
              'A'
            ]
          ],
          'H'
        ]
      ],
      'A'
    ]

    expect(Crimp.to_a(obj)).to eq(expected)
  end
end

describe 'Objects' do
  it 'raise an error if not in the list of allowed primitives' do
    expect { Crimp.signature(Object.new) }
      .to raise_error(TypeError, 'Expected a (String|Number|Boolean|Nil|Hash|Array), Got Object.')
  end
end
