class Api::CompaniesController < ApiController

  def index
    companies = if params[:id]
      Category.find_by(name: params[:id]).companies
    else
      Company.all
    end

    respond_with companies.with_project_count.page(params[:page])
  end
end
