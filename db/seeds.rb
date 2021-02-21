# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'json'
require 'open-uri'

def seed_ingredients
  puts 'Cleaning database...'
  Ingredient.delete_all

  url = 'https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'
  drink_serialized = open(url).read
  drink = JSON.parse(drink_serialized)

  drink['drinks'].each do |i|
    ingredient = Ingredient.create!(
      name: i['strIngredient1']
    )
    puts ingredient.name
  end
end

def seed_cocktails
  puts 'cleaning up cocktail'
  Cocktail.delete_all
  url_base = "https://source.unsplash.com/600x400/?"
  cocktails = [
    'Bourbon Old Fashioned',
    'Negroni',
    'Manhattan',
    'Long Island Iced Tea',
    'White Russian'
  ]

  cocktails.each do |attributes|
    cocktail = Cocktail.create!(
      name: attributes
      # img_url: url_base + attributes.slice(' ')
    )
    puts cocktail.name
  end
end

seed_cocktails
