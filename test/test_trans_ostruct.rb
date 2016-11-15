
require 'struct_trans/test'
require 'struct_trans/ostruct'

describe 'StructTrans.trans_ostruct' do
  def trans struct, *schemas
    StructTrans.trans_ostruct(struct, *schemas)
  end

  would 'raise StructTrans::UnknownSchema for bad type' do
    message = expect.raise(StructTrans::UnknownSchema) do
      StructTrans.trans_ostruct('nnf', 1)
    end.message

    expect(message).include?('1')
  end

  would 'raise StructTrans::UnknownNestedSchema for bad type' do
    message = expect.raise(StructTrans::UnknownNestedSchema) do
      StructTrans.trans_ostruct('nnf', :reverse => 1)
    end.message

    expect(message).include?('1')
  end

  would 'raise StructTrans::KeyTaken for duplicated keys' do
    message = expect.raise(StructTrans::KeyTaken) do
      StructTrans.trans_ostruct('nnf', :reverse, :reverse)
    end.message

    expect(message).include?('reverse')
  end

  would 'raise StructTrans::NoMap for bad collection data' do
    message = expect.raise(StructTrans::NoMap) do
      StructTrans.trans_ostruct('nnf', [:upcase] => :downcase)
    end.message

    expect(message).include?('NNF')
  end

  would 'transform with symbol' do
    o = trans('nnf', :reverse)

    expect(o.reverse).eq 'fnn'
  end

  would 'transform with array' do
    o = trans('nnf', :reverse, :capitalize)

    expect(o.reverse)   .eq 'fnn'
    expect(o.capitalize).eq 'Nnf'
  end

  would 'transform with hash' do
    o = trans('nnf', :reverse => :capitalize)

    expect(o.reverse.capitalize).eq 'Fnn'
  end

  would 'transform with array containing hashes' do
    o = trans('nnf', :upcase, {:reverse => :capitalize})

    expect(o.upcase)            .eq 'NNF'
    expect(o.reverse.capitalize).eq 'Fnn'
  end

  would 'transform with array containing hashes containing arrays' do
    o = trans('nnf', :upcase, {:reverse => [:capitalize, :upcase]})

    expect(o.upcase)            .eq 'NNF'
    expect(o.reverse.capitalize).eq 'Fnn'
    expect(o.reverse.upcase)    .eq 'FNN'
  end

  would 'transform with array containing hashes containing hashes' do
    o = trans('nnf', :upcase, {:reverse => {:capitalize => :swapcase}})

    expect(o.upcase)                     .eq 'NNF'
    expect(o.reverse.capitalize.swapcase).eq 'fNN'
  end

  would 'transform with array containing hashes containing mixed arrays' do
    o = trans('nnf',
      :upcase, {:reverse => [{:capitalize => :swapcase}, :upcase]})

    expect(o.upcase)                     .eq 'NNF'
    expect(o.reverse.capitalize.swapcase).eq 'fNN'
    expect(o.reverse.upcase)             .eq 'FNN'
  end

  would 'transform with collections' do
    n = 'nnf'
    o = trans(n, [:chars] => :upcase)

    o.chars.each.with_index do |c, i|
      expect(c.upcase).eq n[i].upcase
    end
  end

  would 'transform with multiple collections' do
    n = 'nnf'
    o = trans(n, [:chars, :lines] => :upcase)

    o.chars.each.with_index do |c, i|
      expect(c.upcase).eq n[i].upcase
    end

    expect(o.lines.map(&:upcase)).eq [n.upcase]
  end
end
