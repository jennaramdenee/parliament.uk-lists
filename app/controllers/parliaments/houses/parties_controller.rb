module Parliaments
  module Houses
    class PartiesController < ApplicationController
      before_action :data_check, :build_request

      ROUTE_MAP = {
        index: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.parliaments(params[:parliament_id]).houses(params[:house_id]).parties }
      }.freeze

      def index
        @parliament, @house, @parties, @letters = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
          @request,
          'http://id.ukpds.org/schema/ParliamentPeriod',
          'http://id.ukpds.org/schema/House',
          'http://id.ukpds.org/schema/Party',
          ::Grom::Node::BLANK
        )

        @parliament = @parliament.first
        @house      = @house.first
        @parties    = @parties = @parties.multi_direction_sort({ member_count: :desc, name: :asc })
        @letters    = @letters.map(&:values)
      end

    end
  end
end
