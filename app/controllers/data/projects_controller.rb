class Data::ProjectsController < ApplicationController

  def index

    @projects = Project.joins([:company, :category]).includes([:company, :category])

    if params[:company_id].present?
      @projects = @projects.where(company_id: params[:company_id]).order('title asc')
    else
      @projects = @projects.order('companies.name asc')
    end

    if params[:category_id].present?
      @projects = @projects.where(category_id: params[:category_id])
    end

    @projects = @projects.page(params[:page].to_i)

  end

end
