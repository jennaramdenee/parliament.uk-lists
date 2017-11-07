class TestController < ApplicationController
  # before_action :data_check, :build_request

  AWESOME_HASH = {
    'Party': {
        schema: ['Party'],
        all_path: :parties_path,
        request: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.party_by_initial.set_url_params({ initial: params[:letter] }) }
      },
    'ConstituencyGroup': {
        schema: ['ConstituencyGroup'],
        all_path: :constituencies_path,
        request: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.constituency_by_initial.set_url_params({ initial: params[:letter] }) }
      }
  }

  def letters
    type_info = params[:type].to_sym # => 'Party', 'ConstituencyGroup'
    @type, @letters = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
      AWESOME_HASH[type_info][:request].call(params),
      Parliament::Utils::Helpers::RequestHelper.namespace_uri_schema_path(type_info),
      ::Grom::Node::BLANK
    )

    @letters = @letters.map(&:value)
    @all_path = AWESOME_HASH[type_info][:all_path]

    if type_info == 'Party'
      @parties = @type.sort_by(:name)
      render 'parties/letters'
    elsif type_info == 'ConstituencyGroup'
      @constituencies = @type.multi_direction_sort({name: :asc, start_date: :desc})
      render 'constituencies/letters'
    end

  end
end


# def letters
#   @constituencies, @letters = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
#     @request,
#     Parliament::Utils::Helpers::RequestHelper.namespace_uri_schema_path('ConstituencyGroup'),
#     ::Grom::Node::BLANK
#   )
#
#   @constituencies = @constituencies.multi_direction_sort({name: :asc, start_date: :desc})
#   @letters = @letters.map(&:value)
#   @all_path = :constituencies_path
# end
