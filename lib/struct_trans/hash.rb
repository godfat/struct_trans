


module StructTrans
  module_function

  def trans_hash struct, *schemas
    transform(:hash, struct, schemas)
  end

  def construct_hash
    {}
  end

  def write_hash hash, key, value
    raise KeyTaken.new("Key already taken: #{key.inspect}") if
      hash.key?(key)

    hash[key] = value
  end
end
