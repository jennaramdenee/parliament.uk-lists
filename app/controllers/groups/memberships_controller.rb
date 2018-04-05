module Groups
  class MembershipsController < ApplicationController
    before_action :data_check, :build_request

    ROUTE_MAP = {
      index: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.group_members_current.set_url_params({ group_id: params[:group_id]}) },
    }.freeze

    def index
      @group, @memberships, @people, @formal_body_chairs = Parliament::Utils::Helpers::FilterHelper.filter(
        @request,
        'Group',
        'FormalBodyMembership',
        'Person',
        'Position'
      )

      @group = @group.first
      # @formal_body_chairs = @formal_body_chairs.each do |chair|
      #   chair.incumbencies.map(&:people).sort_by(:name)
      # end
      #
      # @people = (@people - @formal_body_chairs)

      @members = @memberships.map(&:formalBodyMembershipHasPerson).flatten!
    end
  end
end
