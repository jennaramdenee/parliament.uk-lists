class ConstituenciesController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    index:             proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.constituencies },
    lookup_by_letters: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.constituencies.partial(params[:letters]) },
    a_to_z_current:    proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.constituencies.current.a_z_letters },
    current:           proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.constituencies.current },
    letters:           proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.constituencies(params[:letter]) },
    current_letters:   proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.constituencies.current(params[:letter]) },
    a_to_z:            proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.constituencies.a_z_letters }
  }.freeze

  # Renders a list of all constituencies with current incumbents and sorted in ascending order by name from a GET request. Shown with an a - z partial view.
  # @return [Array] Grom::Nodes of type 'http://id.ukpds.org/schema/ConstituencyGroup'.
  def index
    @constituencies, @letters = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
      @request,
      'http://id.ukpds.org/schema/ConstituencyGroup',
      ::Grom::Node::BLANK
    )

    @constituencies = @constituencies.sort_by(:name)
    @letters = @letters.map(&:value)
  end

  # Renders a list of all constituencies with current incumbents and sorted in ascending order by name from a GET request. Shown with an a - z partial view.
  # @return [Array] Grom::Nodes of type 'http://id.ukpds.org/schema/ConstituencyGroup'.
  def current
    @constituencies, @letters = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
      @request,
      'http://id.ukpds.org/schema/ConstituencyGroup',
      ::Grom::Node::BLANK
    )

    @constituencies = @constituencies.sort_by(:name)
    @letters = @letters.map(&:value)
  end

  # Renders a list of constituencies that begin with a particular letter given the letter. Shown with an a - z partial view.
  # @controller_action_param :letter [String] single letter that is case insensitive.
  # @return [Array] Grom::Nodes of type 'http://id.ukpds.org/schema/ConstituencyGroup'.
  def letters
    @constituencies, @letters = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
      @request,
      'http://id.ukpds.org/schema/ConstituencyGroup',
      ::Grom::Node::BLANK
    )

    @constituencies = @constituencies.sort_by(:name)
    @letters = @letters.map(&:value)
  end

  # Renders a list of current constituencies that begin with a particular letter given the letter. Shown with an a - z partial view.
  # @controller_action_param :letter [String] single letter that is case insensitive.
  # @return [Array] Grom::Nodes of type 'http://id.ukpds.org/schema/ConstituencyGroup'.
  def current_letters
    @constituencies, @letters = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
      @request,
      'http://id.ukpds.org/schema/ConstituencyGroup',
      ::Grom::Node::BLANK
    )

    @constituencies = @constituencies.sort_by(:name)
    @letters = @letters.map(&:value)
  end

  # Renders a list of letters taken from first letter of all constituencies. Shown with an a - z partial view.
  # @return [Array] letters representing all constituencies.
  def a_to_z
    @letters = Parliament::Utils::Helpers::RequestHelper.process_available_letters(@request)
  end

  # Renders a list of letters taken from first letter of all current constituencies. Shown with an a - z partial view.
  # @return [Array] letters representing all current constituencies.
  def a_to_z_current
    @letters = Parliament::Utils::Helpers::RequestHelper.process_available_letters(@request)
  end

  # Look up to find a constituency given a string.  Redirects to either a single constituency or list of constituencies.
  # @controller_action_param :letters [String] case insensitive string to lookup.
  def lookup_by_letters
    @constituencies, @letters = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
      @request,
      'http://id.ukpds.org/schema/ConstituencyGroup',
      ::Grom::Node::BLANK
    )

    if @constituencies.size == 1
      redirect_to constituency_path(@constituencies.first.graph_id)
      return
    end

    @constituencies = @constituencies.sort_by(:name)
    @letters = @letters.map(&:value)
  end
end
