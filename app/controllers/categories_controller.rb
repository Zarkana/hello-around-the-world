class CategoriesController < ApplicationController
  before_filter :authenticate_user!

  def index
    authorize! :index, Category
    @categories = Category.accessible_by(current_ability)
  end

  def show
    redirect_to categories_path
  end

  def new
    @category = Category.new
    authorize! :new, @category
  end

  def create
    @category = Category.new(category_params)
    @category.user = current_user
    @category.default = false
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
      @errors = @category.errors
      render 'new'
    end
  end

  def edit
    redirect_to categories_path
  end

  def update
    redirect_to categories_path
  end

  def destroy
    @category = Category.find(params[:id])
    if @category.destroy
      @categories = Category.accessible_by(current_ability)
      redirect_to categories_path
    else
      # @errors = @category.errors
      # @errors[:base] << "Categories cannot be destroyed if they are still being used to describe any code snippets."
      respond_to do |format|
        format.html { redirect_to categories_path, alert: "Categories cannot be destroyed if they are still being used to describe any code snippets."}
      end
    end
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
      params.require(:category).permit(:name, :active)
    end
end
