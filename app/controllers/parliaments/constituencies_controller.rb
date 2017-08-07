module Parliaments
  class ConstituenciesController < ApplicationController
    before_action :data_check, :build_request

    ROUTE_MAP = {
      index:   proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.parliament_constituencies.set_url_params({ parliament_id: params[:parliament_id] }) },
      a_to_z:  proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.parliament_constituencies.set_url_params({ parliament_id: params[:parliament_id] }) },
      letters: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.parliament_constituencies_by_initial.set_url_params({ parliament_id: params[:parliament_id], initial: params[:letter] }) }
    }.freeze

    def index
      @parliament, @constituencies, @letters = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
        @request,
        'http://id.ukpds.org/schema/ParliamentPeriod',
        'http://id.ukpds.org/schema/ConstituencyGroup',
        ::Grom::Node::BLANK
      )

      @parliament     = @parliament.first
      @constituencies = @constituencies.sort_by(:name)
      @letters        = @letters.map(&:value)
    end

    def a_to_z
      @parliament, @constituencies, @letters = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
        @request,
        'http://id.ukpds.org/schema/ParliamentPeriod',
        'http://id.ukpds.org/schema/ConstituencyGroup',
        ::Grom::Node::BLANK
      )

      @parliament     = @parliament.first
      @constituencies = @constituencies.sort_by(:name)
      @letters        = @letters.map(&:value)
    end

    def letters
      @parliament, @constituencies, @letters = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
        @request,
        'http://id.ukpds.org/schema/ParliamentPeriod',
        'http://id.ukpds.org/schema/ConstituencyGroup',
        ::Grom::Node::BLANK
      )

      @parliament     = @parliament.first
      @constituencies = @constituencies.sort_by(:name)
      @letters        = @letters.map(&:value)
    end
  end
end
