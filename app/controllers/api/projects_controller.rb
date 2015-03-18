class Api::ProjectsController < ApiController

  def index
    @projects = Project.joins([:company, :category]).includes([:company, :category])

    if params[:company_id].present?
      @projects = @projects.where(company_id: params[:company_id]).order('title asc')
    else
      @projects = @projects.order('permits_count desc, companies.name asc')
    end

    if params[:category_id].present?
      @projects = @projects.where(category_id: params[:category_id])
    end

    respond_with @projects.page(params[:page].to_i)
  end

  def show
    respond_with Project.find(params[:id])
  end
end
