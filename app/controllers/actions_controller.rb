class ActionsController < ApplicationController
  def index
    @project = current_user.id
    if current_project != nil
      @all_hist = History.where("project_id=?", current_project.id)
      @all_iss = Issue.where("project_id=?", current_project.id)
      @get_hist_time = History.select("created_at").where("project_id=?",
        current_project.id)
      @day = (History.select("created_at").where("project_id=?",current_project.id)+
        (Issue.select("created_at").where("project_id=?", current_project.id))).uniq(&:created_at)
      @d= []
      @day.each do |day|
        @d.push(day.created_at.strftime("%Y-%m-%d"))
      end
      @d.uniq!
      @issue_add = Issue.where("project_id",current_project.id)
      @issue_update = History.includes(:issue).where("project_id=?",current_project.id)
      redirect_to root_url and return unless current_user.activated
    else
      redirect_to root_url
    end
  end
end