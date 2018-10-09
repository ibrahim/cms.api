class Part < ApplicationRecord
  belongs_to :page, optional: true
  belongs_to :structure
end
