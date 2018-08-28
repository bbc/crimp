# Crimp

[![Build Status](https://travis-ci.org/BBC-News/crimp.png?branch=master)](https://travis-ci.org/BBC-News/crimp)
[![Gem Version](https://badge.fury.io/rb/crimp.png)](http://badge.fury.io/rb/crimp)

Creates an MD5 hash from simple data structures made of numbers, strings, booleans, nil, arrays or hashes.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'crimp'

```

And then execute:

```shell
$ bundle

```

Or install it yourself as:

```shell
$ gem install crimp
```

## Usage

```ruby
require 'crimp'

Crimp.signature({ a: { b: 1 } })
=> "ac13c15d07e5fa3992fc6b15113db900"
```

## Multiplatform design

At the BBC we use Crimp to build keys for database and cache entries.

If you want to build a similar library with your language of choice you should be able to follow the simple specifications defined in `spec/crimp_spec.rb`. Using these simple rules you will produce a string ready to be MD5 signed.

Once you get your string, is very important to be sure that you can produce the same key in any language. MD5 is your friend:

### Ruby

```ruby
irb(main):001:0> require 'digest'
=> true
irb(main):002:0> Digest::MD5.hexdigest('abc')
=> "900150983cd24fb0d6963f7d28e17f72"
```

### Lua

```lua
Lua 5.3.5  Copyright (C) 1994-2018 Lua.org, PUC-Rio
> md5 = require 'md5'
> md5.sumhexa('abc')
900150983cd24fb0d6963f7d28e17f72
```

### Elixir

``` elixir
Erlang/OTP 21 [erts-10.0.4] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1] [hipe] [dtrace]
Interactive Elixir (1.7.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> :crypto.hash(:md5 , "abc") |> Base.encode16() |> String.downcase
"900150983cd24fb0d6963f7d28e17f72"
```

### Node.js

``` javascript
> var crypto = require('crypto');
undefined
> crypto.createHash('md5').update('abc').digest('hex');
'900150983cd24fb0d6963f7d28e17f72'
```

## Fine prints

### Symbols

To make Crimp signatures reproducible in any platform we decided to ignore Ruby symbols and treat them as strings, so:

``` ruby
Crimp.signature(:a) == Crimp.Signature('a')
```

### Sets

Also Sets get transformed to Arrays:

``` ruby
Crimp.signature(Set.new(['a', 'b'])) == Crimp.signature(['a', 'b'])
```

### Sorting of collections

Crimp signatures are generated against sorted collections.

```ruby
Crimp.signature([1, 2]) == Crimp.signature([2, 1])
Crimp.signature({'b' => 2, 'a' => 1}) == Crimp.signature({'a' => 1, 'b' => 2})
```

Crimp also sorts nested collections.

```ruby
Crimp.signature([1, [3, 2], 4]) == Crimp.signature([4, [2, 3], 1])
Crimp.signature({'b' => {'d' => 2,'c' => 1}, 'a' => [3, 1, 2]}) == Crimp.signature({'a' => [1, 2, 3], 'b' => { 'c' => 1, 'd' => 2 }})
```

### Custom objects

Crimp will complain if you try to get a signature from an instance of some custom object:

``` ruby
Crimp.signature(Object.new)
=> TypeError: Expected a (String|Number|Boolean|Nil|Hash|Array), Got Object
```
It is your responsibility to pass a compatible representation of your object to Crimp.

## Implementation details

Under the hood Crimp annotates the passed data structure to a nested array of primitives (strings, numbers, booleans, nils, etc.) and a single byte to indicate the type of the primitive:

|  Type   | Byte |
|   :-:   |  :-: |
| String  |  `S` |
| Number  |  `N` |
| Boolean |  `B` |
| nil     |  `_` |
| Array   |  `A` |
| Hash    |  `H` |

You can verify it using the `#annotate` method:

``` ruby
Crimp.annotate({ a: 1 })
=> [[[[[1, "N"], ["a", "S"]], "A"]], "H"]
```
Notice how Crimp marks the collection as Hash (`H`) and then transforms the tuple of key/values to an Array (`A`).

Here's an example with nested hashes:

```ruby
Crimp.annotate({ a: { b: 'c' } })
=> [[[[["a", "S"], [[[[["b", "S"], ["c", "S"]], "A"]], "H"]], "A"]], "H"]
```

Before signing Crimp transforms the collection of nested array to a string.

```ruby
Crimp.notation({ a: { b: 'c' } })
=> "aSbScSAHAH"
```

Please note the Arrays and Hash keys are sorted before signing.

``` ruby
Crimp.notation([3, 1, 2])
=> "1N2N3NA"
```

key/value tuples get sorted as well.

``` ruby
Crimp.notation({ a: 1 })
=> "1NaSAH"
```

## Changelog

| Version | Changes                                                                    |
|---------|----------------------------------------------------------------------------|
|`v0.x`   | Original version of Crimp.                                                 |
|`v0.2.0` | Crimp compatibility with Ruby >= 2.4, use this for legacy projects.        |
|`v1.0.0` | Includes **breaking changes** and returns different signatures from `v0.2` |

## Contributing

1. Fork it ( http://github.com/BBC-News/crimp/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
