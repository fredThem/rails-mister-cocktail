class AddCategoryToCocktails < ActiveRecord::Migration[6.1]
  def change
    add_column :cocktails, :category, :string
  end
end
