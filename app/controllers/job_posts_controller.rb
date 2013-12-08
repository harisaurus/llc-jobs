class JobPostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    if params[:tag]
      @job_posts = JobPost.tagged_with(params[:tag])
    else
      @job_posts = JobPost.all
    end
  end

  def new
    @job_post = JobPost.new
    @categories = Category.all
  end
   
  def create
    @job_post = JobPost.new(job_post_params)

    if @job_post.save
      redirect_to @job_post
    else
      render 'new'
    end
  end

  def show
    @job_post = JobPost.find(params[:id])
    @job_application = @job_post.job_applications.new
  end

  private
  def job_post_params
    params.require(:job_post).permit(:title, :description, :due_date, :tag_list)
  end
end
