class CategoriesController < ApplicationController
  def index
    @categories = Category.all

    respond_to do |format|
      format.html { render 'other/404' }
      format.json { render :index, status: :ok }
    end
  end

  def show
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new
  end

  def edit
    @category = Category.find(params[:id])
    @list = List.find_by id: params[:list_id]
  end

  def create
    space = Space.find_by slug: params[:space_slug]
    list = List.find_by id: params[:list_id]
    @category = space.categories.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to list, notice: 'Category created.' }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render 'new' }
      end
    end
  end

  def update
    list = List.find_by id: params[:list_id]
    @category = Category.find(params[:id])
    space = @category.space

    respond_to do |format|
      if @category.update(category_params)
        if list
          format.html { redirect_to list, notice: 'Edited category.' }
        else
          format.html { redirect_to space, notice: 'Edited category.' }
        end
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render 'edit' }
      end

    end
  end

  def destroy
    list = List.find(params[:list_id])
    category = Category.find(params[:id])
    category.destroy

    respond_to do |format|
      format.html { redirect_to list, notice: 'Category deleted.' }
      format.json { head :no_content }
    end
  end

  private

    def category_params
      params.require(:category).permit(:name, :space_slug)
    end
end