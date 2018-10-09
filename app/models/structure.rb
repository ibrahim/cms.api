
class Structure < ApplicationRecord
  has_many :pages
  has_many :parts
  belongs_to :site
  has_and_belongs_to_many :pages

end
