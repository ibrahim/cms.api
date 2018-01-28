class Domain < ApplicationRecord
    belongs_to :site, optional: true
end
