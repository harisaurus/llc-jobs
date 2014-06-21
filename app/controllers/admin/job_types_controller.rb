class Admin::JobTypesController < Admin::AdminAreaController
  def index
    @job_types = JobType.all
    @job_type = JobType.new
  end

  def create
    @job_type = JobType.new(job_type_params)

    if @job_type.save
      redirect_to :admin_job_types
    else
      render 'new'
    end
  end

  def destroy
    @job_type = JobType.find(params[:id])
    if @job_type.job_posts.empty?
      @job_type.destroy
      redirect_to :admin_job_types
    else
      redirect_to :admin_job_types, alert: "It has job posts"
    end
  end

  private
  def job_type_params
    params.require(:job_type).permit(:name)
  end
end
