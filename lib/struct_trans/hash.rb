


module StructTrans
  module_function

  def trans_hash struct, *schemas
    transform(:hash, struct, schemas)
  end

  def construct_hash
    {}
  end

  def write_hash hash, key, value
    hash[key] = value
  end
end
