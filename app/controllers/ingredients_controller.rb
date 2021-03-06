class IngredientsController < ApplicationController
  before_action :redirect_if_not_logged_in
  layout  "layout"



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
      @ingredients = Ingredient.all    
    end
  end

  def show
     @ingredient = Ingredient.find_by_id(params[:id])
  end

  def edit
    @ingredient = Ingredient.find_by_id(params[:id])       
  end
 
  def update 
    @ingredient = Ingredient.find_by(id: params[:id])    
      redirect_to ingredient_path if !@ingredient 
      if @ingredient.update(ingredient_params)
        redirect_to recipe_ingredient_path(@ingredient)    
      else
       render :edit
      end
  end

    def destroy
      Ingredient.find(params[:id]).destroy
      redirect_to recipe_path
    end

private

   def ingredient_params
     params.require(:ingredient).permit(:name, :quantity, :measurement, :recipe_id)
   end
end