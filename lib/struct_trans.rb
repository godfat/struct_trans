
require 'struct_trans/hash'

module StructTrans
  module_function

  def transform kind, struct, schemas
    schemas.inject(
      public_send("construct_#{kind}"),
      &method(:transform_for).curry[kind, struct])
  end

  def transform_for kind, struct, result, schema, *extra
    case schema
    when Symbol
      public_send("write_#{kind}", result, schema, struct.public_send(schema))

    when Hash
      schema.each do |key, nested_schema|
        nested_struct = struct.public_send(key)
        nested_value = case nested_schema
                       when Hash, Symbol
                         transform(kind, nested_struct, [nested_schema])
                       when Array
                         transform(kind, nested_struct, nested_schema)
                       else
                         raise TypeError.new(
                           "Unknown nested schema: #{nested_schema.inspect}")
                       end

        public_send("write_#{kind}", result, key, nested_value)
      end
    else
      raise TypeError.new("Unknown schema: #{schema.inspect}")
    end

    result
  end
end
