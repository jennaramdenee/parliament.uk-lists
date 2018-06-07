require 'rails_helper'

RSpec.describe 'groups/positions/chairs/index', vcr: true do
  before do
    assign(:group, (double(:group, name: 'GroupName', graph_id: 'wZVxomZk')))
    assign(:chairs,
               [double(:chairs,
                 name: 'chairName',
                 incumbencies: [double(:incumbencies,
                   start_date: Time.zone.now,
                   date_range: '2015 to 2017',
                   people: [double(:people,
                     display_name: 'full name',
                     graph_id: 'h34f8JKl',
                     current_party: (double(:party,
                       name: 'Labour')
                       )
                      )
                    ]
                   )
                 ]
               )
              ]
             )
    render
  end

  context 'header' do
    it 'will render the correct header' do
      expect(rendered).to match(/Current and former chairs of the GroupName/)
    end
  end

  it 'will render position incumbents name' do
    expect(rendered).to match(/full name/)
  end

  it 'will render position incumbents party' do
    expect(rendered).to match(/Labour/)
  end

  it 'will render position incumbents date range' do
    expect(rendered).to match(/2015 to 2017/)
  end
end
