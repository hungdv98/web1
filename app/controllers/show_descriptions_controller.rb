class ShowDescriptionsController < ApplicationController
  def show
    @issues = Issue.where("project_id=?", session[:project_id]).order("id ASC")
    @history = History.find_by id: params[:id]
    @update_day = @history.distince_date(@history.created_at)
  end
end