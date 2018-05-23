class WorkPackagesController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    index: proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.work_package_index },
  }.freeze

  def index
    @work_packages = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'WorkPackage')

    @work_packages = Parliament::NTriple::Utils.multi_direction_sort({
      list: @work_packages.nodes,
      parameters: { oldest_business_item_date: :desc, name: :asc },
      prepend_rejected: false
    })
  end
end
