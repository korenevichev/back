# Accommodation
#
# Model for accommodations table
class Person < ApplicationRecord
  has_one :descriptor, dependent: :destroy, foreign_key: :person_id
end
