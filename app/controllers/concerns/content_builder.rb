module ContentBuilder
  extend ActiveSupport::Concern

  def apply_operation(operation)
    operation.instructions.each { |instruction| update_content(instruction) }
  end

  def update_content(instruction)
    send(instruction.kind)
    update_revision
    save!
  end

  def insert_content(instruction)
    content.insert(instruction.position, instruction.character)
  end

  def delete_content(instruction)
    content.slice!(instruction.position)
  end

  def update_revision
    revision = revision + 1
  end
end