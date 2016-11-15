
require 'struct_trans/hash'

module StructTrans
  UnknownSchema = Class.new(ArgumentError)
  KeyTaken = Class.new(ArgumentError)
  NoMap = Class.new(TypeError)

  module_function

  def transform kind, struct, schemas
    schemas.inject(
      public_send("construct_#{kind}"),
      &method(:transform_for).curry[kind, struct])
  end

  def transform_for kind, struct, result, schema
    case schema
    when Symbol
      public_send("write_#{kind}", result, schema, struct.public_send(schema))
    when Hash
      schema.each(&method(:transform_for_hash).curry[kind, struct, result])
    else
      raise UnknownSchema.new("Unknown schema: #{schema.inspect}")
    end

    result
  end

  def transform_for_hash kind, struct, result, (key, schema)
    # Workaround Ruby's curried function doesn't have proper arity set.
    # Hash#each would only give key value separated if arity is 2,
    # while curried transform_for_hash should have arity of 2 shows as -1 :(
    case key
    when Symbol
      value = transform_for_nested(
        kind, struct.public_send(key), schema)

      public_send("write_#{kind}", result, key, value)

    when Array
      key.each do |list_key|
        list = struct.public_send(list_key)

        unless list.respond_to?(:map)
          raise NoMap.new(
            "Not responding to map:" \
            " #{struct.class}##{list_key} -> #{list.inspect}")
        end

        value = list.map do |nested_struct|
                  transform_for_nested(kind, nested_struct, schema)
                end

        public_send("write_#{kind}", result, list_key, value)
      end

    else
      if key.respond_to?(:call)
        transform_for_nested(kind, key.call(struct), schema).
          each do |wrapped_key, value|
            public_send("write_#{kind}", result, wrapped_key, value)
          end
      else
        raise UnknownSchema.new("Unknown schema: #{key.inspect}")
      end
    end
  end

  def transform_for_nested kind, struct, schema
    case schema
    when Hash, Symbol
      transform(kind, struct, [schema])
    when Array
      transform(kind, struct, schema)
    else
      raise UnknownSchema.new("Unknown schema: #{schema.inspect}")
    end
  end
end
