class Admin::DashboardController < Admin::AdminAreaController
  def index

  end

  def new_admin
    @admin = Admin.new
  end

  def create_admin
    @admin = Admin.new(admin_params)

    if @admin.save
      redirect_to :admin_dashboard
    else
      render 'new_admin'
    end
  end

 def edit
    @admin = current_admin
  end

  def update_password
    @admin = Admin.find(current_admin.id)
    if @admin.update_with_password(admin_params)
      sign_in @admin, :bypass => true
      redirect_to :admin_dashboard
    else
      render "edit"
    end
  end

  private
  def admin_params
    params.require(:admin).permit(:email, :password, :password_confirmation, :current_password)
  end
end
