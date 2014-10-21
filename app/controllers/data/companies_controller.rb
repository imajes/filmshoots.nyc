class Data::CompaniesController < ApplicationController

  def index

    if params[:category_id]
      @companies = Category.find(params[:category_id]).companies
    else
      @companies = Company.all
    end

    @companies = @companies.order("name asc").page(params[:page].to_i)

  end

end
