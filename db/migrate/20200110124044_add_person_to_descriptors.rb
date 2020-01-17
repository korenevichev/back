class AddPersonToDescriptors < ActiveRecord::Migration[5.2]
  def change
    add_reference :descriptors, :person, foreign_key: true
  end
end
