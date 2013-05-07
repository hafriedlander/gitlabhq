class UsersController < ApplicationController
  before_filter :authorize_create_user!, only: [:new, :create]

  def show
    @user = User.find_by_username!(params[:username])
    @projects = @user.authorized_projects.where('projects.id in (?)', current_user.authorized_projects.map(&:id))
    @events = @user.recent_events.where(project_id: @projects.map(&:id)).limit(20)
  end

  def new
    @admin_user = User.new()
  end

  def create
    admin = params[:user].delete("admin")

    @admin_user = User.new(params[:user])
    @admin_user.admin = false
    @admin_user.force_random_password = true

    respond_to do |format|
      if @admin_user.save
        format.html { redirect_to @admin_user, notice: 'User was successfully created.' }
        format.json { render json: @admin_user, status: :created, location: @admin_user }
      else
        format.html { render action: "new" }
        format.json { render json: @admin_user.errors, status: :unprocessable_entity }
      end
    end
  end

  def authorize_create_user!
    unless can?(current_user, :create_user, nil)
      return render_404
    end
  end
end
