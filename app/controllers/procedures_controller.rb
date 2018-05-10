class ProceduresController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    index: proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.procedure_index },
  }.freeze

  def index
    @procedures = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'Procedure')
    @procedures = @procedures.sort_by(:name)
  end
end
