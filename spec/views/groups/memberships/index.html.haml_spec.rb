require 'rails_helper'

RSpec.describe 'groups/memberships/index', vcr: true do
  before do
    assign(:groups, [double(:group, name: 'GroupName', graph_id: 'P7Ne09WK')])
    assign(:members,
      [
        double(
          :member,
          display_name: 'Display Name 1',
          current_party_membership: { current_party_membership: { party: { name: 'Labour'} } },
          current_seat_incumbency: { constituency: { name: 'Islington North' } },
          current_mp?: true,
          alternate?: true

        )
      ]
    )
    render
  end

end
