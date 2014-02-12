# Crimp

[![Build Status](https://travis-ci.org/BBC-News/crimp.png?branch=master)](https://travis-ci.org/BBC-News/crimp)
[![Gem Version](https://badge.fury.io/rb/crimp.png)](http://badge.fury.io/rb/crimp)

Creating an md5 hash of a number, string, array, or hash in Ruby

![mighty-boosh-four-way-crimp-o](https://f.cloud.github.com/assets/180050/2148112/b44fd6fa-93de-11e3-9f9a-ad941f069b5c.gif)

Shamelessly copied from [this Stack Overflow
answer](http://stackoverflow.com/a/6462589/3243663).

## Installation

Add this line to your application's Gemfile:

    gem 'crimp'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install crimp

## Usage

```rb
require 'crimp'

Crimp.stringify({:a => {:b => 'b', :c => 'c'}, :d => 'd'})

# => [\"aSymbol=>[\\\"bSymbol=>b\\\", \\\"cSymbol=>c\\\"]Array\",\"dSymbol=>d\"]Array"

Crimp.signature({:a => {:b => 'b', :c => 'c'}, :d => 'd'})

# => "68d07febc4f47f56fa6ef5de063a77b1"

```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/crimp/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
