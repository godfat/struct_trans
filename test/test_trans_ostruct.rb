
require 'struct_trans/test'
require 'struct_trans/ostruct'

describe 'StructTrans.trans_ostruct' do
  def trans struct, *schemas
    StructTrans.trans_ostruct(struct, *schemas)
  end

  would 'raise TypeError for bad type' do
    expect.raise(TypeError) do
      StructTrans.trans_ostruct('nnf', 1)
    end
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
end
