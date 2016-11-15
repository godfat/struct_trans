
require 'struct_trans/hash'

module StructTrans
  module_function

  def transform kind, struct, schema
    case schema
    when Symbol
      struct.public_send(schema)
    when Array
      schema.map do |key|
        transform(kind, struct, key)
      end
    when Hash
      schema.inject(public_send("construct_#{kind}")) do |box, (key, value)|
        public_send("write_#{kind}",
          box, key, transform(kind, struct.public_send(key), value))
        box
      end
    else
      raise TypeError.new("Unknown type: #{schema.class}: #{schema}")
    end
  end
end
