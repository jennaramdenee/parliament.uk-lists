module People
  class MembersController < ApplicationController
    before_action :data_check, :build_request

    ROUTE_MAP = {
      index:           proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.people.members },
      current:         proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.people.members.current },
      letters:         proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.people.members(params[:letter]) },
      current_letters: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.people.members.current(params[:letter]) },
      a_to_z:          proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.people.members.a_z_letters },
      a_to_z_current:  proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.people.members.current.a_z_letters }

      # New Data API URL structure
      # index:           proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.member_index },
      # current:         proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.member_current },
      # letters:         proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.member_by_initial.set_url_params({ initial: params[:letter] }) },
      # current_letters: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.member_current_by_initial.set_url_params({ initial: params[:letter] }) },
      # a_to_z:          proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.member_a_to_z },
      # a_to_z_current:  proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.member_current_a_to_z }
    }.freeze

    def index
      @people, @letters = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
        @request,
        'http://id.ukpds.org/schema/Person',
        ::Grom::Node::BLANK
      )

      @people = @people.sort_by(:sort_name)
      @letters = @letters.map(&:value)
    end

    def current
      @people, @letters = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
        @request,
        'http://id.ukpds.org/schema/Person',
        ::Grom::Node::BLANK
      )

      @people = @people.sort_by(:sort_name)
      @letters = @letters.map(&:value)
    end

    def letters
      @people, @letters = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
        @request,
        'http://id.ukpds.org/schema/Person',
        ::Grom::Node::BLANK
      )

      @people = @people.sort_by(:sort_name)
      @letters = @letters.map(&:value)
    end

    def current_letters
      @people, @letters = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
        @request,
        'http://id.ukpds.org/schema/Person',
        ::Grom::Node::BLANK
      )

      @people = @people.sort_by(:sort_name)
      @letters = @letters.map(&:value)
    end

    def a_to_z
      @letters = Parliament::Utils::Helpers::RequestHelper.process_available_letters(@request)
    end

    def a_to_z_current
      @letters = Parliament::Utils::Helpers::RequestHelper.process_available_letters(@request)
    end
  end
end
