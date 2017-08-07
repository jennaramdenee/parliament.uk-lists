module Houses
  class PartiesController < ApplicationController
    before_action :data_check, :build_request

    ROUTE_MAP = {
      index:   proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.house_parties.set_url_params({ house_id: params[:house_id] }) },
      current: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.house_current_parties.set_url_params({ house_id: params[:house_id] }) },
      show:    proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.house_party_by_id.set_url_params({ house_id: params[:house_id], party_id: params[:party_id] }) }
    }.freeze

    def index
      @house, @parties = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
        @request,
        'http://id.ukpds.org/schema/House',
        'http://id.ukpds.org/schema/Party'
      )

      @house = @house.first
      @parties = @parties.sort_by(:name)
    end

    def current
      @house, @parties = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
        @request,
        'http://id.ukpds.org/schema/House',
        'http://id.ukpds.org/schema/Party'
      )

      @house = @house.first
      @parties = @parties.multi_direction_sort({ member_count: :desc, name: :asc })
    end
  end
end
