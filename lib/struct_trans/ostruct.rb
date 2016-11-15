
require 'ostruct'

module StructTrans
  module_function

  def trans_ostruct struct, *schemas
    transform(:ostruct, struct, schemas)
  end

  def construct_ostruct
    OpenStruct.new
  end

  def write_ostruct ostruct, key, value
    message = "#{key}="

    raise KeyTaken.new("key #{key} is already taken") if
      ostruct.respond_to?(message)

    ostruct.public_send(message, value)
  end
end
