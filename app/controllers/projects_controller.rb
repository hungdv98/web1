class ProjectsController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :show]
  helper_method :sort_column, :sort_direction

  def index
    if params[:search].nil?
      @project = Project.order(sort_column + " " + sort_direction).page params[:page]
    else
      @project = Project.search(params[:search]).page params[:page]
    end
    @count = Project.count
    @list_assiged = UserProject.where("user_id = ?", current_user.id)
  end

  def new
    @project = Project.new
    @assign_member = UserProject.new
  end

  def create
    @emo = Emoji.all
    @user = User.all
    @project = Project.new(project_params)
    if @project.save
      if params[:check_user] == nil
      else
        params[:check_user].each do |k|
          UserProject.transaction do
            UserProject.create project_id: @project.id, user_id: k
          end
        end
      end
      flash[:info] = t "cr_success"
      redirect_to projects_url
    else
      flash[:danger] = t "cr_danger"
      render :new
    end
  end

  def show
    @allEmo = Emoji.first
    @project = Project.find(params[:id])
    tmp = UserProject.where("project_id = ?", @project.id)
    @display = tmp.ids
    @retIssue = Issue.where("project_id = ?", @project.id)
    @retTask = @retIssue.where("type_issue = ?", 1)
    @retBug = @retIssue.where("type_issue = ?", 2)
  end

  def edit
    @project = Project.find(params[:id])
    tmp = UserProject.where("project_id = ?", @project.id)
    @display = tmp.ids
  end

  def update
    @project = Project.find(params[:id])
    tmp = UserProject.where("project_id = ?", @project.id)
    @display = tmp.ids
    if @project.update_attributes(project_params)
      UserProject.destroy(tmp.ids)
      if params[:qqq] == nil

      else
        params[:qqq].each do |k|
          UserProject.transaction do
            UserProject.create project_id: @project.id, user_id: k
          end
        end
      end
      flash[:success] = t "up_success"
      redirect_to projects_path
    else
      flash[:danger] = t "up_danger"
      render :edit
    end
  end

  def destroy
    Project.find(params[:id]).destroy
    flash[:success]  = t "dt_success"
    redirect_to projects_url
  end

  private

  def project_params
    params.require(:project).permit(:name, :description, :status, :active, :user_id)
  end

  def assign_member_params
    params.require(:userproject).permit(:project_id, :user_id)
  end

  def sort_column
    Project.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end