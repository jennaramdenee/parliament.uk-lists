require 'rails_helper'

RSpec.describe 'houses/members/a_to_z_current', vcr: true do
  before do
    assign(:house_id, 'KL2k1BGP')
    assign(:letters, 'A')
    @house = Class.new
    allow(@house).to receive(:name).and_return('House of Commons')
    render
  end

  it 'will render pugin/components/_navigation-letter' do
    expect(response).to render_template(partial: 'pugin/components/_navigation-letter', locals: { route_args: ['KL2k1BGP'] })
  end
end
