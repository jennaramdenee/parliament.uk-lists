module Groups
  class MembershipsController < ApplicationController
    before_action :data_check, :build_request

    ROUTE_MAP = {
      index: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.group_members_current.set_url_params({ group_id: params[:group_id]}) },
    }.freeze

    def index
      group, people, formal_body_chairs = Parliament::Utils::Helpers::FilterHelper.filter(
        @request,
        'Group',
        'Person',
        'Position'
      )

      @group = group.first
      @people = people.nodes
      formal_body_chairs.each do |chair_position|
        @formal_body_chair_members = chair_position.incumbencies.map(&:people).flatten!.uniq!
      end

      @non_chair_members = (@people - @formal_body_chair_members)
    end
  end
end
