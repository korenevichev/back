class AddUniqueToPerson < ActiveRecord::Migration[5.2]
  def change
    add_index :people, :surname, unique: true
  end
end
