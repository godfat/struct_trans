
require 'struct_trans/test'
require 'struct_trans/ostruct'

describe 'StructTrans.trans_ostruct' do
  def trans struct, schema
    StructTrans.trans_ostruct(struct, schema)
  end

  would 'transform with symbol' do
    o = trans('nnf', :reverse)

    expect(o).eq 'fnn'
  end

  would 'transform with array' do
    o = trans('nnf', [:reverse, :capitalize])

    expect(o[0]).eq 'fnn'
    expect(o[1]).eq 'Nnf'
  end

  would 'transform with hash' do
    o = trans('nnf', {:reverse => :capitalize})

    expect(o.reverse).eq 'Fnn'
  end

  would 'transform with array containing hashes' do
    o = trans('nnf', [:reverse, {:reverse => :capitalize}])

    expect(o[0]).eq 'fnn'
    expect(o[1].reverse).eq 'Fnn'
  end

  would 'transform with array containing hashes containing arrays' do
    o = trans('nnf', [:reverse, {:reverse => [:capitalize, :upcase]}])

    expect(o[0]).eq 'fnn'
    expect(o[1].reverse[0]).eq 'Fnn'
    expect(o[1].reverse[1]).eq 'FNN'
  end

  would 'transform with array containing hashes containing hashes' do
    o = trans('nnf', [:reverse, {:reverse => {:capitalize => :swapcase}}])

    expect(o[0]).eq 'fnn'
    expect(o[1].reverse.capitalize).eq 'fNN'
  end

  would 'transform with array containing hashes containing mixed arrays' do
    o = trans('nnf',
      [:inspect, {:reverse => [{:capitalize => :swapcase}, :upcase]}])

    expect(o[0]).eq '"nnf"'
    expect(o[1].reverse[0].capitalize).eq 'fNN'
    expect(o[1].reverse[1]).eq 'FNN'
  end
end
