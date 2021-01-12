module OperationTransformer
  extend ActiveSupport::Concern

  def transform_operation(operation, document)
    new_operations_ids = document.operations.operations_later_than(operation.revision)
    new_instructions = Instruction.where(operation_id: new_operations_ids)
    apply_transform(operation, new_instructions)
  end

  def apply_transform(operation, instructions)
    operation.instructions.each do |instructionA|
      instructions.each do |instructionB|
        send("transform_#{instructionA.status}_#{instructionB.status}", instructionA, instructionB)
      end
    end
  end
end