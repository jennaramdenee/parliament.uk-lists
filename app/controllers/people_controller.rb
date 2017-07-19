class PeopleController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    index:             proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.people },
    letters:           proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.people(params[:letter]) },
    a_to_z:            proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.people.a_z_letters },
    lookup_by_letters: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.people.partial(params[:letters]) }
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

  def letters
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

  def lookup_by_letters
    @people, @letters = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
      @request,
      'http://id.ukpds.org/schema/Person',
      ::Grom::Node::BLANK
    )

    return redirect_to person_path(@people.first.graph_id) if @people.size == 1

    @people = @people.sort_by(:name)
    @letters = @letters.map(&:value)
  end
end
