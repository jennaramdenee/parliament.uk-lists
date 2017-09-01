require 'rails_helper'

RSpec.describe 'parties/members/a_to_z', vcr: true do
  before do
    assign(:letters, 'A')
    assign(:party_id, 'jF43Jxoc')
    @party = Class.new
    allow(@party).to receive(:name).and_return('Labour')
    render
  end

  it 'will render pugin/components/_navigation-letter' do
    expect(response).to render_template(partial: 'pugin/components/_navigation-letter')
  end
end
