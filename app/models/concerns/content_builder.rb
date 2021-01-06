module ContentBuilder
  extend ActiveSupport::Concern

  def apply_operation(operation)
    operation.instructions.each { |instruction| update_content(instruction) }
  end

  def update_content(instruction)
    send(instruction.status + "_content", instruction)
    update_revision
    save!
  end

  def ins_content(instruction)
    content.insert(instruction.position, instruction.character)
  end

  def del_content(instruction)
    content.slice!(instruction.position)
  end

  def update_revision
    self.revision = self.revision + 1
  end
end