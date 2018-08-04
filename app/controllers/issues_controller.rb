class IssuesController < ApplicationController
  before_action :find_issue, only:[:edit, :update, :destroy, :show, :update_parent_task]
  before_action :count_issue, only:[:edit, :index]
  before_action :show_time, only:[:edit, :show]
  helper_method :sort_column, :sort_direction
  before_action :create_issue_relationship, only:[:show, :edit]
  before_action :show_issue_with_project, only:[:show, :edit, :add_time, :update]
  
  def index
    if (params[:status].nil? && params[:asignee].nil? &&
      params[:priority].nil? && params[:tracker].nil? )
      @issues = Issue.where("project_id=?", session[:project_id]).order(sort_column + " " +
        sort_direction).page params[:page]
    else
      if params[:priority].nil?
        @i_priority = "priority !=? and"
        params[:value_priority] = ""
      elsif params[:select_content_priority].values == ["is not"]
        @i_priority = "priority !=? and"
        params[:value_priority] = params[:value_priority].values
      else
        @i_priority = "priority =? and"
        params[:value_priority] = params[:value_priority].values
      end
      if params[:select_content_assignee].values == ["is not"]
        @i_assignee = "assignee !=? and"
      else
        @i_assignee = "assignee =? and"
      end
      if params[:tracker].nil?
        @i_tracker = "type_issue !=?"
        params[:value_tracker] = ""
      elsif params[:select_content_tracker].values == ["is not"]
        @i_tracker = "type_issue !=?"
        params[:value_tracker] = params[:value_tracker].values
      else
        @i_tracker = "type_issue =?"
        params[:value_tracker] = params[:value_tracker].values
      end
      if params[:asignee].nil? & params[:status].nil?
        @issues = Issue.where("project_id=? and #{@i_priority} #{@i_tracker}",
          session[:project_id], params[:value_priority], params[:value_tracker]).page params[:page]
      elsif params[:asignee].nil?
        @issues = Issue.where("project_id=? and status =? and #{@i_priority} #{@i_tracker}",
          session[:project_id], params[:value_status].values,
          params[:value_priority], params[:value_tracker]).page params[:page]
      elsif params[:status].nil?
        @issues = Issue.where("project_id=? and #{@i_assignee} #{@i_priority} #{@i_tracker}",
          session[:project_id], params[:value_assignee].values,
          params[:value_priority], params[:value_tracker]).page params[:page]
      else
        @issues = Issue.where("project_id=? and status=? and #{@i_assignee}
          #{@i_priority} #{@i_tracker}", session[:project_id],
          params[:value_status].values, params[:value_assignee].values,
          params[:value_priority], params[:value_tracker]).page params[:page]
      end
    end
  end

  def show
    $arr_parent = []
    @histories = History.where("issue_id = ?", params[:id]).page params[:page]
    @id_pre = @issues[params[:index].to_i-2].id
    if params[:index].to_i != @issues.count
      @id_next = @issues[params[:index].to_i].id
    else
      @id_next = params[:index]
    end
    find_subtask(@issue.id)
    @x = $arr_parent
  end

  def new
  	@issue  = Issue.new
  end

  def search
    if(params[:current_issue].nil?)
      @auto = Issue.where("id=? and project_id=?", params[:search], session[:project_id])
      if @auto.blank?
        @auto = Issue.where("project_id=? and subject LIKE?", session[:project_id], "%#{params[:search]}%")
      end
    else
      @auto = Issue.where("id=? and id!=? and project_id=?", params[:search], params[:current_issue], session[:project_id])
      if @auto.blank?
        @auto = Issue.where("project_id=? and subject LIKE? and id!=?", session[:project_id], "%#{params[:search]}%", params[:current_issue])
      end
    end
  end

  def create
    @issue = Issue.new issue_params
    @issue.user_id = current_user.id
    if current_project != nil
      @issue.project_id = current_project.id
    end
    @issue.description = params[:description]
    if(@issue.parent_id.nil? || Issue.where("project_id=? and id=?", session[:project_id], @issue.parent_id).count!=0)
      if @issue.save
        flash[:success] = t "cr_success"
        if params[:commit] == t("btn_save")
          redirect_to issues_path
        else
          redirect_to new_issue_path
        end
      else
        render :new
      end
    else
      flash[:danger] = "Parent_id invalid!"
      render :new
    end

  end

  def edit
    @histories = History.where("issue_id = ?", params[:id]).page params[:page]
  end

  def update
    $arr_parent = []
    find_subtask(@issue.id)
    @check = $arr_parent
    @check.each do |x|
      if x == issue_params[:parent_id].to_i
        @check= issue_params[:parent_id]
      end
    end
    a = Hash[issue_id: @issue.id, type_issue: @issue.type_issue,
      subject: @issue.subject, description: @issue.description,
      status: @issue.status, priority: @issue.priority,
      assignee: @issue.assignee, start_date: @issue.start_date,
      expired_date: @issue.expired_date, estimate_time: @issue.estimate_time,
      percent_progress: @issue.percent_progress, user_id: @issue.user_id,
      project_id: @issue.project_id, parent_id: @issue.parent_id]
      if(issue_params[:parent_id]=="" || (Issue.where("project_id=? and id=?", session[:project_id], issue_params[:parent_id]).count!=0 && issue_params[:parent_id]!=@check) )
        if @issue.update_attributes(issue_params)
          @issue.update_attribute :description, params[:description]
          b = Hash[issue_id: @issue.id, type_issue: @issue.type_issue,
          subject: @issue.subject, description: @issue.description,
          status: @issue.status, priority: @issue.priority,
          assignee: @issue.assignee, start_date: @issue.start_date,
          expired_date: @issue.expired_date, estimate_time: @issue.estimate_time,
          percent_progress: @issue.percent_progress, user_id: @issue.user_id,
          project_id: @issue.project_id, parent_id: @issue.parent_id]
          if a!=b
            hash = {}
            (a.keys & b.keys).each {|k|
              if a[k]!=b[k]
                hash.store(k, "thay doi tu #{a[k]} thanh #{b[k]}")
              end
              hash.store(:issue_id, @issue.id)
              hash.store(:user_id, current_user.id)
              hash.store(:project_id, @issue.project_id)
            }
              History.create hash
          end
          flash[:success] = t "up_success"
          redirect_to issues_path
        else
          flash[:danger] = t "up_danger"
          render :edit
        end
      else
        flash[:danger] = "Paren_id invalid!"
        render :edit
      end
  end

  def destroy
    Issue.find_by(id: params[:id]).destroy
    flash[:success] = t "dt_success"
    redirect_to issues_path
  end

  def destroy_multiple
    if params[:issues].nil?
    else
      Issue.destroy(params[:issues])
      respond_to do |format|
        format.html { redirect_to issues_path; flash[:success] = "delete success" }
        format.json { head :no_content }
      end
    end

  end

  def add_time
    @issue = Issue.find_by id: params[:id]
    @estimate_time_last= @issue.estimate_time
    @issue.estimate_time = ((Issue.find_by id: params[:id]).estimate_time.to_i +
      params[:estimate_time].to_i).to_s+ ".00"
    @issues.each_with_index do |item, index|
      if item.id == @issue.id
        @vt = index+1;
      end
    end
    if @issue.save
      History.create issue_id: @issue.id, user_id: @issue.user_id,
        project_id: @issue.project_id,
        estimate_time: "thay doi tu #{@estimate_time_last} thanh #{@issue.estimate_time}"
      flash[:success] = t "cr_success"
      if params[:commit] == t("btn_save")
        redirect_to "http://localhost:3000/issues/#{@issue.id}?index=#{@vt}"
      else
        render "add_times/edit"
      end
    else
      flash[:danger] = t "cr_danger"
      render :edit
    end
  end

  def choose_type_issue
    @template = IssueTemplate.where("type_template=?", params[:choose_type_issue])
  end

  def choose_template
    @content = IssueTemplate.find_by(id: params[:choose_template])
  end

  private

  def find_issue
  	@issue = Issue.find_by id: params[:id]
  end

  def count_issue
    @count = Issue.where("project_id=?", session[:project_id]).count;
  end

  def show_issue_with_project
    @issues = Issue.where("project_id=?", session[:project_id]).order("id ASC")
  end

  def issue_params
    params.require(:issue).permit(:type_issue, :subject,
      :status, :priority, :assignee, :start_date, :expired_date,
      :estimate_time, :percent_progress, :created_at, :parent_id,
      :choose_type_issue, {pictures: []})
  end

  def show_time
    @create_day = @issue.distince_date(@issue.created_at)
    @update_day = @issue.distince_date(@issue.updated_at)
  end

  def sort_column
    Issue.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def create_issue_relationship
    @issue_relationship  = IssueRelationship.new
    @relationship = IssueRelationship.where("issue_id=?", 1)
  end
end