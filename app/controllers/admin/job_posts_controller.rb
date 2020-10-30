class Admin::JobPostsController < Admin::AdminAreaController
  before_action :load_job_post, only: [:activate, :hide_or_show, :reject, :edit, :update, :toggle_featured]

  def index
    @job_posts = JobPost.order("created_at DESC").paginate(page: params[:page])
  end

  def reject
    @job_post.reject
    redirect_to :admin_job_posts
  end

  def activate
    @job_post.activate
    redirect_to :admin_job_posts
  end

  def hide_or_show
    if @job_post.hidden?
      @job_post.show
    elsif @job_post.active?
      @job_post.hide
    end
    redirect_to :admin_job_posts
  end

  def toggle_featured
    @job_post.update_attributes(featured: !@job_post.featured?)
    redirect_to :admin_job_posts, notice: @job_post.featured? ? "Successfully featured this job" : "Successfully unfeatured this job"
  end

  def new
    @job_post = JobPost.new
    @categories = Category.all
    @job_types = JobType.all
  end

  def create
    @job_post = current_admin.job_posts.new(job_post_params)
    @job_post.state = 'not_approved'

    if @job_post.save
      @job_post.activate
      redirect_to @job_post
    else
      @categories = Category.all
      @job_types = JobType.all
      render 'new'
    end
  end

  def edit
    @categories = Category.all
    @job_types = JobType.all
  end

  def update
    if @job_post.update(job_post_params)
      redirect_to @job_post, :notice => "Your post is updated"
    else
      @categories = Category.all
      @job_types = JobType.all
      render 'edit'
    end
  end

  private
  def load_job_post
    @job_post = JobPost.find(params[:id])
  end

  def job_post_params
    params.require(:job_post).permit(:title, :description, :how_to_apply, :company, :due_date, :tag_list, :category_id, :job_type_id, :city, :country)
  end
end
