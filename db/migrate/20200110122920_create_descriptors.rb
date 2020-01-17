class CreateDescriptors < ActiveRecord::Migration[5.2]
  def change
    create_table :descriptors do |t|
      t.binary :descriptor_values
    end
  end
end
