class JobPostsController < ApplicationController
  # before_action :authenticate_employer!, only: [:new, :create, :edit, :update]

  def index
    @job_posts = JobPost.all
  end

  def new
    @job_post = JobPost.new
  end
   
  def create
    @job_post = JobPost.new(job_post_params)

    if @job_post.save
      redirect_to @job_post
    else
      render 'new'
    end
  end

  private
  def job_post_params
    params.require(:job_posts).permit(:title, :description, :due_date)
  end
end
