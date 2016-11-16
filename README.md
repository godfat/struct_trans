# StructTrans [![Build Status](https://secure.travis-ci.org/godfat/struct_trans.png?branch=master)](http://travis-ci.org/godfat/struct_trans) [![Coverage Status](https://coveralls.io/repos/github/godfat/struct_trans/badge.png)](https://coveralls.io/github/godfat/struct_trans) [![Join the chat at https://gitter.im/godfat/struct_trans](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/godfat/struct_trans)

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
  :inspect, {:reverse => [{:capitalize => :swapcase}, :upcase]})
  # {:inspect => '"nnf"', :reverse => {:capitalize => {:swapcase => 'fNN'}, :upcase => 'FNN'}}
```

We could also transform the same struct (i.e. `'nnf'`) into an open struct
rather than a hash if you prefer.

``` ruby
require 'struct_trans/ostruct'

o = StructTrans.trans_ostruct(
  'nnf',
  :upcase, {:reverse => [{:capitalize => :swapcase}, :upcase]})

p o.upcase # 'NNF'
p o.reverse.capitalize.swapcase # 'fNN'
p o.reverse.upcase # 'FNN'
```

## Demonstrations

Consider that you have a `User` model and `Message` model.
You want to expose them to the external world.

``` ruby
User = Struct.new(:id, :legacy_name, :messages)
Message = Struct.new(:content, :sender)

require 'forwardable'

module Trans
  def trans_hash *extra
    StructTrans.trans_hash(self, *self.class.schema(*extra))
  end
end

module Entity
  def entity *extra
    {method(:new) => schema(*extra)}
  end
end

UserEntity = Struct.new(:user) do
  extend Forwardable
  def_delegator :user, :legacy_name, :name
  def_delegators :user, :id, :messages

  include Trans
  extend Entity
  def self.schema *extra
    [:name] + extra
  end
end

MessageEntity = Struct.new(:message) do
  extend Forwardable
  def_delegators :message, :content, :sender

  include Trans
  extend Entity
  def self.schema *extra
    [:content, {:sender => UserEntity.entity(:id)}] + extra
  end
end

user = User.new(0, 'Fungi')
messages = [Message.new('nnf', user), Message.new('mmf', user)]
user.messages = messages

p UserEntity.new(user).trans_hash(:id, [:messages] => MessageEntity.entity)
# {:id => 0, :name => 'Fungi', :messages => [{:content => 'nnf', :sender => {:id => 0, :name => 'Fungi'}}, {:content => 'mmf', :sender => {:id => 0, :name => 'Fungi'}}]}
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
