class Ingredient < ApplicationRecord
  # belongs_to :cocktail
  has_many :doses
  validates_presence_of :name
  validates_uniqueness_of :name
end
