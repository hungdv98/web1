class SearchIssuesController < ApplicationController
  def search
    @issues = Issue.where("project_id=?", session[:project_id])
    @q = Issue.where("id=? and project_id=?", params[:q], session[:project_id])
    if !@q.blank?
      @issues.each_with_index do |issue, index|
        if issue.id == @q[0].id
          @vt = index+1
        end
      end
    end
  end
end