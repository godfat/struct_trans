
require 'struct_trans/test'

describe 'StructTrans.trans_hash' do
  def verify struct, *schemas, result
    expect(StructTrans.trans_hash(struct, *schemas)).eq result
  end

  would 'raise TypeError for bad type' do
    expect.raise(TypeError) do
      StructTrans.trans_hash('nnf', 1)
    end
  end

  would 'transform with symbol' do
    verify('nnf', :reverse, {:reverse => 'fnn'})
  end

  would 'transform with array' do
    verify('nnf', :reverse, :capitalize,
      {:reverse => 'fnn', :capitalize => 'Nnf'})
  end

  would 'transform with hash' do
    verify('nnf', {:reverse => :capitalize},
      {:reverse => {:capitalize => 'Fnn'}})
  end

  would 'transform with array containing hashes' do
    verify('nnf',
      :inspect, {:reverse => :capitalize},
      {:inspect => '"nnf"', :reverse => {:capitalize => 'Fnn'}})
  end

  would 'transform with array containing hashes containing arrays' do
    verify('nnf',
      :inspect, {:reverse => [:capitalize, :upcase]},
      {:inspect => '"nnf"',
       :reverse => {:capitalize => 'Fnn', :upcase => 'FNN'}})
  end

  would 'transform with array containing hashes containing hashes' do
    verify('nnf',
      :inspect, {:reverse => {:capitalize => :swapcase}},
      {:inspect => '"nnf"',
       :reverse => {:capitalize => {:swapcase => 'fNN'}}})
  end

  would 'transform with array containing hashes containing mixed arrays' do
    verify('nnf',
      :inspect, {:reverse => [{:capitalize => :swapcase}, :upcase]},
      {:inspect => '"nnf"',
       :reverse => {:capitalize => {:swapcase => 'fNN'}, :upcase => 'FNN'}})
  end

  would 'transform with collections' do
    verify('nnf',
      {[:chars] => :upcase},
      {:chars => [{:upcase => 'N'}, {:upcase => 'N'}, {:upcase => 'F'}]})
  end
end
