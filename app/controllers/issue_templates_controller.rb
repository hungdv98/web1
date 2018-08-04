class IssueTemplatesController < ApplicationController
  before_action :find_template, only: [:edit, :update, :show]
  def index
    @templates = IssueTemplate.all.page params[:page]
  end

  def show
  end

  def new
    @template = IssueTemplate.new
  end

  def create
    @template = IssueTemplate.new template_params
    if @template.save
      flash[:success] = "Create success!"
      redirect_to issue_templates_path
    else
      render :new
    end
  end

  def edit
    @template = IssueTemplate.find_by id: params[:id]
  end

  def update
    if @template.update_attributes(template_params)
      flash[:success] = t "up_success"
      redirect_to issue_templates_path
    else
      flash[:danger] = t "up_danger"
      render :edit
    end
  end

  def destroy
    IssueTemplate.find(params[:id]).destroy
    flash[:success] = "Delete success!"
    redirect_to issue_templates_url
  end

  private

  def find_template
    @template = IssueTemplate.find_by id: params[:id]
  end

  def template_params
    params.require(:issue_template).permit(:name, :type_template, :description)
  end
end