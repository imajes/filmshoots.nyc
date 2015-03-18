class Api::CompaniesController < ApiController

  def index
    companies = if params[:category_name]
      Category.find_by(name: params[:category_name]).companies
    else
      Company.all
    end

    respond_with companies.page(params[:page])
  end
end
