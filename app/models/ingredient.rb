class Ingredient < ApplicationRecord
  # belongs_to :cocktail
  validates_presence_of :name
  uniqueness_of :name
end
