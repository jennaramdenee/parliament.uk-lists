require 'rails_helper'

RSpec.describe 'groups/memberships/member', vcr: true do
  before do
    assign(:groups, [double(:group, name: 'GroupName', graph_id: 'P7Ne09WK')])
    assign(:members,
      [
        double(:member,
          display_name: 'Display Name 1',
          graph_id: 'g7g7g7g7',
          current_party_membership:
            double(:current_party_membership, party:
              double(:party, name: 'Labour')
            ),
          current_seat_incumbency:
            double(:current_seat_incumbency, constituency:
              double(:constituency, name: 'Islington North')
            ),
          current_mp?: true,
          former_mp?: false,
          current_lord?: false,
          former_lord?: false,
          alternate?: true,
          lay_member?: false,
          ex_officio?: false
        ),

        double (:member,
          display_name: 'Display Name 2',
          graph_id: 'h8h8h8h8',
          current_party_membership:
            double(:current_party_membership, party:
              double(:party, name: 'Conservative')
            ),
          statuses: { house_membership_status: ['Member of the House of Lords'] },
          current_mp?: false,
          former_mp?: false,
          current_lord?: true,
          former_lord?: false,
          alternate?: true,
          lay_member?: false,
          ex_officio?: false
        )
      ]
    )
    render
  end

  

end
