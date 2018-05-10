class WorkPackagesController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    index: proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.work_package_index },
  }.freeze

  def index
    @work_packageable_things = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'WorkPackageableThing')

    @work_packageable_things = Parliament::NTriple::Utils.multi_direction_sort({
      list: @work_packageable_things.nodes,
      parameters: { oldest_business_item_date: :desc, name: :asc },
      prepend_rejected: false
    })
  end
end
