class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end

  def show
    # @category = Category.find(params[:id])
    redirect_to categories_path
  end

  def new
    @category = Category.new
  end

  def edit
    # @category = Category.find(params[:id])
    redirect_to categories_path
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to categories_path
    else
      render 'new'
    end
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
