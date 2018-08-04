class MyPagesController < ApplicationController
  def show
    @issues = Issue.order("id ASC")
    @issue = Issue.includes(:project).where("assignee=?",current_user.id)
    @issue_add = Issue.includes(:project).where("user_id=?",current_user.id)
  end
end