class Tagging < ApplicationRecord
    belongs_to :tag, optional: true
    belongs_to :content, polymorphic: true, optional: true
end
