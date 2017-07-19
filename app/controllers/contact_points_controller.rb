class ContactPointsController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    index: proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.contact_points },
    show:  proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.contact_points(params[:contact_point_id]) }
  }.freeze

  def index
    @contact_points = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
      @request,
      'http://id.ukpds.org/schema/ContactPoint'
    )
  end

end
