class IssueRelationshipsController < ApplicationController
  def new
    @issue_relationship  = IssueRelationship.new
  end

  def create
    @issue_relationship = IssueRelationship.new issue_params
    @issue_relationship.issue_id = params[:issue_id]
    @issue_relationship.project_id = params[:project_id]
    if (find_subtask(params[:issue_id]).select {|val| val == @issue_relationship.issue_relation}).blank?
      if (@issue_relationship.issue_relation==nil ||
        Issue.where("project_id=? and id=?", params[:project_id], @issue_relationship.issue_relation).count!=0 &&
        Issue.where("id=? and parent_id=?", params[:issue_id], @issue_relationship.issue_relation).count==0 &&
        IssueRelationship.where("issue_relation=?",@issue_relationship.issue_relation).count==0)
        if @issue_relationship.save
          flash[:success] = "Create success!"
        else
          flash[:danger] = "failed"
          redirect_to issues_path
        end
      end
    else
      (find_subtask(params[:issue_id]).select {|val| val == @issue_relationship.issue_relation}).each do |check|
        if (@issue_relationship.issue_relation==nil || (Issue.where("project_id=? and id=?", params[:project_id], @issue_relationship.issue_relation).count!=0) && @issue_relationship.issue_relation!=check)
        if @issue_relationship.save
          flash[:success] = "Create success!"
        else
          flash[:danger] = "failed"
          redirect_to issues_path
        end
      end
      end
    end
  end

  def destroy
    IssueRelationship.find_by(id: params[:id]).destroy
    respond_to do |format|
      format.js {render inline: "location.reload(true);" }
    end
  end

  def issue_params
    params.require(:issue_relationship).permit(:type_relationship, :issue_relation)
  end
end