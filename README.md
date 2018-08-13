# Crimp

[![Build Status](https://travis-ci.org/BBC-News/crimp.png?branch=master)](https://travis-ci.org/BBC-News/crimp)
[![Gem Version](https://badge.fury.io/rb/crimp.png)](http://badge.fury.io/rb/crimp)

Creates an MD5 hash of a data structure made of numbers, strings, booleans, arrays, sets or hashes.

## Installation

Add this line to your application's Gemfile:

```ruby
$ gem 'crimp'

```

And then execute:

```ruby
$ bundle

```

Or install it yourself as:

```ruby
$ gem install crimp
```

## Usage

```ruby
require 'crimp'

Crimp.signature({ a: { b: 1 } })
=> 1d30be4e0d607268513228ca38ef53cb
```

Under the hood Crimp reduces the passed data structure to a nested array of primitives (strings, numbers, booleans, nils) and a single byte to indicate the type of the primitive: `s` for strings, `n` for numbers, `b` for booleans, `_` for nils.

|  Type   | byte |
|   :-:   |  :-: |
| String  |  `s` |
| Number  |  `n` |
| Boolean |  `b` |
| nil     |  `_` |

You can verify it using the '#to_a' method:

```ruby
Crimp.to_a({ a: { b: 'c' } })
=> [[["a", "s"], [[["b", "s"], ["c", "s"]]]]]
```

Please note the Arrays, Sets and Hash keys are sorted before signing.

``` ruby
Crimp.to_a([3,1,2])
=> [[1, "n"], [2, "n"], [3, "n"]]
```

key/value tuples get sorted as well.

``` ruby
Crimp.to_a({ a: 1 })
=> [[[1, "n"], ["a", "s"]]]
```

Finally, a last implemantation detail: before signing, the array get flattened to a single array and transformed to a single string, you can verify it with `#to_s`:

```ruby
Crimp.to_s({ a: 1 })
=> 1nas
```

## Multiplatform

At the BBC we use Crimp to build keys for database and cache entries. Is very important to be sure that we can produce the same key  in any language. MD5 is your friend:

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
> m = md5.new()
> md5.sumhexa('abc')
900150983cd24fb0d6963f7d28e17f72
```

### Elixir

``` elixir
Erlang/OTP 21 [erts-10.0.4] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1] [hipe] [dtrace]
Interactive Elixir (1.7.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> :crypto.hash(:md5 , "abc") |> Base.encode16()
"900150983CD24FB0D6963F7D28E17F72"
```

If you want to build a similiar library with your language of choice you should be able to follow the simple specifications defined in `spec/crimp_spec.rb`


## Fine prints

To make Crimp signatures reproducible in any platform we decided to ignore Ruby symbols and treat them as strings, so:

``` ruby
Crimp.signature(:a) == Crimp.Signature('a')
```

Also remember that collections gets sorted so:

``` ruby
Crimp.signature([2,1]) == Crimp.Signature([1,2])
```

Crimp will complain if you try to get a signature from an instance of some custom object:

``` ruby
Crimp.signature(Object.new)
=> ArgumentError
```
It is your responsibility to pass a hash/array representation of your object to Crimp.


## Changelog

| version | Changes                                                        |
|---------|----------------------------------------------------------------|
|`0.x`    | original version of Crimp. Use this for legacy projects.       |
|`1.x`    | includes breaking changes in both method signature and output. |

## Contributing

1. Fork it ( http://github.com/<my-github-username>/crimp/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
