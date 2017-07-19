module Parliaments
  class MembersController < ApplicationController
    before_action :data_check, :build_request

    ROUTE_MAP = {
      index:   proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.parliaments(params[:parliament_id]).members },
      a_to_z:  proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.parliaments(params[:parliament_id]).members },
      letters: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.parliaments(params[:parliament_id]).members(params[:letter]) }
    }.freeze

    def index
      @parliament, @people, @letters = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
        @request,
        'http://id.ukpds.org/schema/ParliamentPeriod',
        'http://id.ukpds.org/schema/Person',
        ::Grom::Node::BLANK
      )

      @parliament = @parliament.first
      @people     = @people.sort_by(:sort_name)
      @letters    = @letters.map(&:value)
    end

    def letters
      @parliament, @people, @letters = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
        @request,
        'http://id.ukpds.org/schema/ParliamentPeriod',
        'http://id.ukpds.org/schema/Person',
        ::Grom::Node::BLANK
      )

      @parliament = @parliament.first
      @letters    = @letters.map(&:value)
      @people     = @people.sort_by(:sort_name)
    end

    def a_to_z
      @parliament, @letters = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
        @request,
        'http://id.ukpds.org/schema/ParliamentPeriod',
        ::Grom::Node::BLANK
      )

      @parliament = @parliament.first
      @letters    = @letters.map(&:value)
    end
  end
end
