class Structure < ApplicationRecord
  has_many :pages
  belongs_to :site
  has_and_belongs_to_many :pages
end
