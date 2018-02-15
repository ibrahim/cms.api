class Structure < ApplicationRecord
  has_many :pages
  belongs_to :site
end
