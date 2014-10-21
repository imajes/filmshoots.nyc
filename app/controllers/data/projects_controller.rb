class Data::ProjectsController < ApplicationController

  def index
    @projects = Project.joins(:company).includes(:company).order("companies.name asc").page(params[:page].to_i)

  end

end
