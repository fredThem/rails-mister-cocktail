# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'json'
require 'open-uri'

# thecocktaildb API
# https://www.thecocktaildb.com/api.php

# Lookup full cocktail details by id
# https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=11007

# Search cocktail by name
# https://www.thecocktaildb.com/api/json/v1/1/search.php?s=margarita

# Search by ingredient
# https://www.thecocktaildb.com/api/json/v1/1/filter.php?i=Gin
# https://www.thecocktaildb.com/api/json/v1/1/filter.php?i=Vodka

# Filter by Category
# https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Ordinary_Drink
# https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Cocktail

def serialize(url)
  data_serialized = open(url).read
  data = JSON.parse(data_serialized)
end

def drinks_categories
  categories = []
  puts 'listing categories'
  url = 'https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list'
  serialized_categories = serialize(url)
  # puts serialized_categories
  serialized_categories['drinks'].each do |category|
    value = category.values[0]
    categories << value unless value.empty?
  end
  categories
  # ["Ordinary Drink", "Cocktail", "Milk / Float / Shake", "Other/Unknown", "Cocoa", "Shot", "Coffee / Tea", "Homemade Liqueur", "Punch / Party Drink", "Beer", "Soft Drink / Soda"]
end

def seed_ingredients
  puts 'Cleaning database...'
  Ingredient.delete_all
  
  url = 'https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'
  drink = serialize(url)
  
  drink['drinks'].each do |i|
    ingredient = Ingredient.create!(
      name: i['strIngredient1']
    )
    puts ingredient.name
  end
end

# ! previous seed_cocktails BEGIN
# def seed_cocktails
#   puts 'cleaning up cocktail'
#   Cocktail.delete_all
#   cocktails = [
#     'Bourbon Old Fashioned',
#     'Negroni',
#     'Manhattan',
#     'Long Island Iced Tea',
#     'White Russian'
#   ]

#   cocktails.each do |attributes|
#     cocktail = Cocktail.create!(
#       name: attributes
#     )
#     puts cocktail.name
#   end
# end
# ! previous seed_cocktails END

def cocktails_by_category
  puts 'cleaning up cocktail'
  Cocktail.delete_all
  
  drinks_categories.each do |category|
    # p category.class
    serialized_drinks = serialize("https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=#{category.sub(' ', '_')}")
    serialized_drinks['drinks'].each do |drink|
      # byebug
      cocktail = Cocktail.create!(
        name: (drink['strDrink']),
        img_url: (drink['strDrinkThumb']),
        category: category
      )
      puts cocktail
    end
  end
  # byebug
  # puts @cocktails.length
end

def seed_doses
  p Cocktail.first
  url = 'https://www.thecocktaildb.com/api/json/v1/1/search.php?s='
  # doses = serialize(url)
  
  Cocktail.all.each do |cocktail|
    cocktail.doses.delete_all
    api_url = url + cocktail.name
    serialized_cocktail = serialize(api_url)
    serialized_cocktail['drinks'].each do |attribute|
      p cocktail
      index = 1
      15.times do
        # byebug
                

        measure = attribute["strMeasure#{index}"]
        unless measure.nil?
          ingredient = attribute["strIngredient#{index}"]
          p "#{index}) #{measure} #{ingredient}"
          ingredient_id = Ingredient.find_or_create_by(name: ingredient).id
          
          new_dose = {
            cocktail_id: cocktail.id,
            ingredient_id: ingredient_id,
            description: measure
          }

          # dose = Dose.create!(new_dose)
          dose = cocktail.doses.create!(new_dose)
          # byebug
          # p dose
          # new_dose.save!
        end
        # Ingredient(id: integer, name: string, created_at: datetime, updated_at: datetime)
        # Dose(id: integer, description: string, cocktail_id: integer, ingredient_id: integer, created_at: datetime, updated_at: datetime)
        index += 1
      end
      index = 1
      # byebug
    end
    # cocktail << value unless value.empty?
    byebug
  end
end
seed_doses

# cocktails_by_category
# seed_ingredients
