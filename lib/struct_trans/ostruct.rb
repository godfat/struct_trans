
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
    ostruct.public_send("#{key}=", value)
  end
end
