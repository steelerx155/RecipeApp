class RecipesController < ApplicationController
     before_action :redirect_if_not_logged_in    
     layout  "layout"


    def new
      if params[:user_id] && @user = User.find_by_id(params[:user_id])
        @recipe = @user.recipes.build
        @recipe.ingredients.build
      else
        @recipe = Recipe.new
      end      
    end

    def create   
      @recipe = current_user.recipes.build(recipe_params) 
      if @recipe.save
        redirect_to recipes_path
      else
       render :new
      end
    end

    def index 
      if params[:user_id] && @user = User.find_by_id(params[:user_id])
      @recipes = @user.recipes.alpha
      else
       @recipes = Recipe.alpha
      end
      @recipes = @recipes.search(params[:q].downcase) if params[:q] && !params[:q].empty?
    end
 
    def edit
      @recipe = Recipe.find_by_id(params[:id])
      redirect_to recipes_path if !@recipe || @recipe.user != current_user
    end
    

     def update 
      @recipe = Recipe.find_by(id: params[:id])    
      redirect_to recipe_path if !@recipe || @recipe.user != current_user
      if @recipe.update(recipe_params)
      redirect_to recipe_path(@recipe)    
      else
        render :edit
      end
    end

    def show 
      @recipe = Recipe.find_by_id(params[:id])
      redirect_to recipes_path if !@recipe     
    end


    def destroy
      Recipe.find(params[:id]).destroy
      redirect_to recipe_url
    end

    def most_comments
      @recipes = Recipe.most_comments
    end

    def high_num_ingredients
      @recipes = Recipe.high_num_ingredients
      render :index
    end

  private
    def recipe_params
      params.require(:recipe).permit(:title, :content, ingredients_attributes: [:quantity, :name, :measurement]
       )
    end    
end