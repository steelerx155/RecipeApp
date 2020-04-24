class IngredientsController < ApplicationController
  before_action :redirect_if_not_logged_in


  def new 
    if params[:recipe_id] && @recipe = Recipe.find_by_id(params[:recipe_id])
        @ingredient = @recipe.ingredients.build
    else
        @ingredient = Ingredient.new
       end
  end

  def create
     @ingredient = current_user.ingredients.build(ingredient_params)
       if @ingredient.save
        redirect_to recipes_path
    else
        render :new
    end
  end

  def index
    if params[:recipe_id] && @recipe = Recipe.find_by_id(params[:recipe_id])
       @ingredients = @recipe.ingredients
    else
      @error = "Sorry, that doesn't exist" if params[:recipe_id]
      @ingredients = Ingredient.all    
    end
  end

  def show
     @ingredient = Ingredient.find_by_id(params[:id])
  end

  def edit
     @ingredient = Ingredient.find_by_id(params[:id])
  end


private

   def ingredient_params
         params.require(:ingredient).permit(:name, :quantity, :measurement, :recipe_id)
   end
end


 

  