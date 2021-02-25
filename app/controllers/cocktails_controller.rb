class CocktailsController < ApplicationController
  before_action :set_cocktail, only: [:show]

  def index
    # byebug
    @cocktails = Cocktail.all
  end

  def new
    @cocktail = Cocktail.new # needed to instantiate the form_for
  end

  def create
    @cocktail = Cocktail.new(cocktail_params)

    if @cocktail.save
      redirect_to @cocktail
    else
      render 'new'
    end
  end

  def show
    @dose = Dose.new
  end

  private

  def set_cocktail
    @cocktail = Cocktail.find(params[:id])
  end

  def set_dose
    @dose = Dose.find(params[:id])
  end

  def cocktail_params
    params.require(:cocktail).permit(:name, :img_url, :category)
  end
end
