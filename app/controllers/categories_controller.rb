class CategoriesController < ApplicationController

  before_filter :authenticate_user!

  def index
    @categories = Category.accessible_by(current_ability)
  end

  def show
    # @category = Category.find(params[:id])
    redirect_to categories_path
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    @category.user = current_user
    authorize! :create, @category

    if @category.save

      #If admin we need to store data to be used later for default language look up
      if current_user.admin == true
        @category.default = true;
        @category.update_attributes(
          :default => true,
          :default_id => @category.id
          )
      end

      @categories = Category.accessible_by(current_ability)
      redirect_to categories_path
    else
      render 'new'
    end
  end

  def edit
    # @category = Category.find(params[:id])
    redirect_to categories_path
  end

  def update
    # @category = Category.find(params[:id])
    #
    # if @category.update(category_params)
    #   redirect_to @category
    # else
    #   render 'edit'
    # end
    redirect_to categories_path
  end

  def destroy
    @category = Category.find(params[:id])
    if @category.destroy
      @categories = Category.accessible_by(current_ability)
      # flash[:success] = "Category destroyed Successfully"
      redirect_to categories_path
    else
      respond_to do |format|
        format.html { redirect_to categories_path, alert: "Categories cannot be destroyed if they are still being used to describe any code snippets."}
      end
    end
    # format.html { redirect_to @category, notice: 'Widget was successfully created.' }
  end

  def update_active
    @category = Category.find(params[:id])

    # if @category.update_attributes(:active => params[:active])
    if @category.update_attributes(:active => params[:active])
      # data = {:message => "Worked! " + params[:active]}
      # render :json => data, :status => :ok
    else
      # data = {:message => "Not worked! " + params[:active]}
      # render :json => data, :status => :ok
    end
  end

  private
    def category_params
      params.require(:category).permit(:name)
    end
end
