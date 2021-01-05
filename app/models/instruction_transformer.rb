module InstructionTransformer
  def transformInsIns(instructionA, instructionB)
    if instructionA.position > instructionB.position
      instructionA.position = instructionA.position + 1
    end
    instructionA.save!
  end

  def transformInsDel(instructionA, instructionB)
    if instructionA.position > instructionB.position
      instructionA.position = instructionA.position - 1
    end
    instructionA.save!
  end

  def transformDelIns(instructionA, instructionB)
    if instructionA.position > instructionB.position
      instructionA.position = instructionA.position + 1
    end
    instructionA.save!
  end

  def transformDelDel(instructionA, instructionB)
    if instructionA.position > instructionB.position
      instructionA.position = instructionA.position + 1
      instructionA.save!
    elsif instructionA.position == instructionB.position
      # instruction need to be deleted as duplicate
    end
  end
end