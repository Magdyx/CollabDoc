module InstructionTransformer 
  extend ActiveSupport::Concern
  def transform_ins_ins(instructionA, instructionB)
    if instructionA.position > instructionB.position
      instructionA.position = instructionA.position + 1
    end
    instructionA.save!
  end

  def transform_ins_del(instructionA, instructionB)
    if instructionA.position > instructionB.position
      instructionA.position = instructionA.position - 1
    end
    instructionA.save!
  end

  def transform_del_ins(instructionA, instructionB)
    if instructionA.position > instructionB.position
      instructionA.position = instructionA.position + 1
    end
    instructionA.save!
  end

  def transform_del_del(instructionA, instructionB)
    if instructionA.position > instructionB.position
      instructionA.position = instructionA.position - 1
      instructionA.save!
    elsif instructionA.position == instructionB.position
      # instruction need to be deleted as duplicate
      instructionA.destroy
    end
  end
end