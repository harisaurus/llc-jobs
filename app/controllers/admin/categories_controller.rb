class Admin::CategoriesController < Admin::AdminAreaController
  def index
    @categories = Category.all
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to :admin_categories
    else
      render 'new'
    end
  end

  def destroy
    @category = Category.find(params[:id])
    if @category.job_posts.empty?
      @category.destroy
      redirect_to :admin_categories
    else
      redirect_to :admin_categories, alert: "It has job posts"
    end
  end

  private
  def category_params
    params.require(:category).permit(:name)
  end
end
