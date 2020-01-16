# Descriptor
class Descriptor < ApplicationRecord
  belongs_to :person

  validates :descriptor_values, presence: true
end
