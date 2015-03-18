class ApiController < ApplicationController
  respond_to :json

  rescue_from ActiveRecord::RecordNotFound do
    respond_with [], status: :not_found
  end

end
