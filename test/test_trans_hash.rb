
require 'struct_trans/test'

describe 'StructTrans.trans_hash' do
  def verify struct, schema, result
    expect(StructTrans.trans_hash(struct, schema)).eq result
  end

  would 'raise TypeError for bad type' do
    expect.raise(TypeError) do
      StructTrans.trans_hash('nnf', 1)
    end
  end

  would 'transform with symbol' do
    verify('nnf', :reverse, 'fnn')
  end

  would 'transform with array' do
    verify('nnf', [:reverse, :capitalize], %w[fnn Nnf])
  end

  would 'transform with hash' do
    verify('nnf', {:reverse => :capitalize}, {:reverse => 'Fnn'})
  end

  would 'transform with array containing hashes' do
    verify('nnf',
      [:reverse, {:reverse => :capitalize}],
      ['fnn', :reverse => 'Fnn'])
  end

  would 'transform with array containing hashes containing arrays' do
    verify('nnf',
      [:reverse, {:reverse => [:capitalize, :upcase]}],
      ['fnn', :reverse => ['Fnn', 'FNN']])
  end

  would 'transform with array containing hashes containing hashes' do
    verify('nnf',
      [:reverse, {:reverse => {:capitalize => :swapcase}}],
      ['fnn', :reverse => {:capitalize => 'fNN'}])
  end

  would 'transform with array containing hashes containing mixed arrays' do
    verify('nnf',
      [:inspect, {:reverse => [{:capitalize => :swapcase}, :upcase]}],
      ['"nnf"', {:reverse => [{:capitalize => 'fNN'}, 'FNN']}])
  end
end
