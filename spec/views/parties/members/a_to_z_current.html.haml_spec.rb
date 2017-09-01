require 'rails_helper'

RSpec.describe 'parties/members/a_to_z_current', vcr: true do
  before do
    assign(:letters, 'A')
    assign(:party_id, 'jF43Jxoc')
    @party = Class.new
    allow(@party).to receive(:name).and_return('Labour')
    allow(view).to receive(:house_parties_party_members_current_path).and_return('/houses/Kz7ncmrt/parties/AJgeHzL2/members/current')
    allow(view).to receive(:house_parties_party_members_current_a_z_letter_path).and_return('/houses/Kz7ncmrt/parties/AJgeHzL2/members/current/a-z/a')

    render
  end

  it 'will render pugin/components/_navigation-letter' do
    expect(response).to render_template(partial: 'pugin/components/_navigation-letter')
  end
end
