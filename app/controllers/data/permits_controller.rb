class Data::PermitsController < ApplicationController
  def index
    @permits = Permit.joins([:project, :company]).includes([:project, :company])

    if params[:project_id].present?
      @project = Project.find(params[:project_id])
      @permits = @project.permits
    end

    @permits = @permits.order('event_start asc').page(params[:page].to_i).per(50)
  end
end
