
require 'struct_trans/hash'

module StructTrans
  UnknownSchema = Class.new(TypeError)
  KeyTaken = Class.new(ArgumentError)

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
        case key
        when Symbol
          value = transform_for_nested(
            kind, struct.public_send(key), nested_schema)

          public_send("write_#{kind}", result, key, value)

        when Array
          key.each do |list_key|
            list = struct.public_send(list_key)
            raise T unless list.respond_to?(:map)
            value = list.map do |nested_struct|
                      transform_for_nested(kind, nested_struct, nested_schema)
                    end

            public_send("write_#{kind}", result, list_key, value)
          end
        end

      end
    else
      raise UnknownSchema.new("Unknown schema: #{schema.inspect}")
    end

    result
  end

  def transform_for_nested kind, struct, schema
    case schema
    when Hash, Symbol
      transform(kind, struct, [schema])
    when Array
      transform(kind, struct, schema)
    else
      raise UnknownSchema.new("Unknown nested schema: #{schema.inspect}")
    end
  end
end
