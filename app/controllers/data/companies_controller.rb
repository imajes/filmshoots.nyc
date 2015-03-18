class Data::CompaniesController < ApplicationController

  respond_to :json, :html

  def index
    if params[:category_id]
      @companies = Category.find(params[:category_id]).companies
    else
      @companies = Company.all
    end

    @companies = @companies.order('name asc').page(params[:page])
    respond_with @companies
  end
end
