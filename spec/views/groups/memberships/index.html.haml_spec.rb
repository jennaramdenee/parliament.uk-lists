require 'rails_helper'

RSpec.describe 'groups/memberships/index', vcr: true do
  let!(:group) {
    assign(:group,
      double(:group,
        formal_body_name: 'Test formal body name'
      )
    )
  }

  let!(:formal_body_chair_members) {
    assign(:formal_body_chair_members,
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
        )
      ]
    )
  }

  let!(:non_chair_members) {
    assign(:non_chair_members,
      [
        double(:member,
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
  }

  before(:each) do
    render
  end

  context 'heading' do
    it 'displays correct heading' do
      expect(response).to match(/Test formal body name/)
    end
  end

  context 'formal body chair members' do
    it 'renders members partial for each member' do
      expect(response).to render_template(partial: 'groups/memberships/_member')
    end
  end

  context 'non chair members' do
    it 'renders members partial for each member' do
      expect(response).to render_template(partial: 'groups/memberships/_member')
    end
  end
end
