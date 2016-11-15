# StructTrans [![Build Status](https://secure.travis-ci.org/godfat/struct_trans.png?branch=master)](http://travis-ci.org/godfat/struct_trans) [![Coverage Status](https://coveralls.io/repos/godfat/struct_trans/badge.png?branch=master)](https://coveralls.io/r/godfat/struct_trans?branch=master) [![Join the chat at https://gitter.im/godfat/struct_trans](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/godfat/struct_trans)

by Lin Jen-Shin ([godfat](http://godfat.org))

## LINKS:

* [github](https://github.com/godfat/struct_trans)
* [rubygems](https://rubygems.org/gems/struct_trans)
* [rdoc](http://rdoc.info/github/godfat/struct_trans)
* [issues](https://github.com/godfat/struct_trans/issues) (feel free to ask for support)

## DESCRIPTION:

Transform a struct with a schema to a hash, other struct, or more.

## WHY?

We need an easy way to define how we want to expose data to the external.

## REQUIREMENTS:

* Tested with MRI (official CRuby), Rubinius and JRuby.

## INSTALLATION:

    gem install struct_trans

## SYNOPSIS:

Here's an example to transform a struct-like object, i.e. `'nnf'` into a hash
with a specific schema defined by a hash containing an array containing
another hash and a symbol.

``` ruby
p StructTrans.trans_hash(
  'nnf',
  [:inspect, {:reverse => [{:capitalize => :swapcase}, :upcase]}])
  # ['"nnf"', {:reverse => [{:capitalize => 'fNN'}, 'FNN']}]
```

We could also transform the same struct (i.e. `'nnf'`) into an open struct
rather than a hash if you prefer.

``` ruby
require 'struct_trans/ostruct'

o = StructTrans.trans_ostruct(
  'nnf',
  [:inspect, {:reverse => [{:capitalize => :swapcase}, :upcase]}])

p o[0] # '"nnf"'
p o[1].reverse[0].capitalize # 'fNN'
p o[1].reverse[1] # 'FNN'
```

## CONTRIBUTORS:

* Lin Jen-Shin (@godfat)

## LICENSE:

Apache License 2.0

Copyright (c) 2016, Lin Jen-Shin (godfat)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
