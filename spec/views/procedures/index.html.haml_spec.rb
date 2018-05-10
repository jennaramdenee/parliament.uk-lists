require 'rails_helper'

RSpec.describe 'procedures/index', vcr: true do
  let!(:procedures) {
    assign(:procedures, [procedure])
  }

  let!(:procedure) {
    assign(:procedure,
      double(:procedure,
        name: 'Procedure 1',
        graph_id: 'asdfcvbn'
      )
    )
  }


  before do
    render
  end

  context 'header' do
    it 'will render the correct header' do
      expect(rendered).to match(/Procedures/)
    end
  end

  context 'procedure' do
    it 'will render name' do
      expect(rendered).to have_link('Procedure 1', href: procedure_path('asdfcvbn'))
    end
  end
end
