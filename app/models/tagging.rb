class Tagging < ApplicationRecord
    belongs_to :tag
    belongs_to :content, polymorphic: true
end
