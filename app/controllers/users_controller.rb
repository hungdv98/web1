class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :show]
  #before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :find_user, only:[:edit, :update, :destroy, :show]
  def index
    if params[:search].nil?
      @users = User.order("id ASC").page params[:page]
    else
      @users = User.search(params[:search]).page params[:page]
    end
    @count = User.count;
  end

  def new
    @user = User.new
  end

  def show
    @issues = Issue.order("id ASC")
    @project = UserProject.includes(:project).where("user_id=?",params[:id])
    @d = []
    @issue = Issue.where("user_id=?",@user.id)
    @day = (History.select("created_at").where("user_id = ?", @user.id)+
      (Issue.select("created_at").where("user_id = ?", @user.id))).uniq(&:created_at)
    @day.each do |day|
      @d.push(day.created_at.strftime("%Y-%m-%d"))
    end
    @d.uniq!
    @issue_add = Issue.where("user_id=?",@user.id)
    @issue_update = History.includes(:issue).order("created_at ASC").where("user_id=?",@user.id)
    redirect_to root_url and return unless @user.activated
  end

  def create
    @user = User.new(user_params)
    if logged_in?
      if current_user.user_type==0
        @user.activated = true
        if @user.save
          redirect_to users_path
        else
          render :new
        end
      end
    else
      if @user.save
        @user.send_activation_email
        flash[:info] = t "controllers.user.check_email"
        redirect_to @user
      else
        render :new
      end
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = t "up_success"
      if logged_in?
        if current_user.user_type==0
          redirect_to users_path
        else
          redirect_to @user
        end
      end
    else
      flash[:danger] = t "up_danger"
      render :edit
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = t "dt_success"
    redirect_to root_url
  end

  def block
    user = User.find_by id: params[:id]
    user.status = !user.status
    user.save
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:login_name, :first_name,
    :last_name, :email, :password, :password_confirmation, :user_type, :status)
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "controllers.application.please_login"
      redirect_to login_url
    end
  end

  def correct_user
    @user= User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.user_type==0
  end

  def find_user
  	@user = User.find_by id: params[:id]
  end
end