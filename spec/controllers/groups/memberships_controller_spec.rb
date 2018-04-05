require 'rails_helper'

RSpec.describe Groups::MembershipsController, vcr: true do
  describe 'GET index' do
    before(:each) do
      get :index, params: { group_id: 'P7Ne09WK' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @group and @memberships' do
      expect(assigns(:group)).to be_a(Grom::Node)
      expect(assigns(:group).type).to eq('https://id.parliament.uk/schema/Group')

      assigns(:memberships).each do |membership|
        expect(position).to be_a(Grom::Node)
        expect(position.type).to eq('https://id.parliament.uk/schema/FormalBodyMembership')
      end
    end

    it 'assigns @positions in alphabetical order' do
      expect(assigns(:memberships)[0].name).to eq('membershipName - 1')
      expect(assigns(:memberships)[3].name).to eq('membershipName - 12')
    end

    it 'renders the index template' do
      expect(response).to render_template('index')
    end
  end

  describe '#data_check' do
    context 'an available data format is requested' do
      methods = [
          {
            route: 'index',
            parameters: { group_id: 'P7Ne09WK'},
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/group_positions_index?group_id=ziLwaBLc"
          }
        ]

      before(:each) do
        headers = { 'Accept' => 'application/rdf+xml' }
        request.headers.merge(headers)
      end

      it 'should have a response with http status redirect (302)' do
        methods.each do |method|
          if method.include?(:parameters)
            get method[:route].to_sym, params: method[:parameters]
          else
            get method[:route].to_sym
          end
          expect(response).to have_http_status(302)
        end
      end

      it 'redirects to the data service' do
        methods.each do |method|
          if method.include?(:parameters)
            get method[:route].to_sym, params: method[:parameters]
          else
            get method[:route].to_sym
          end
          expect(response).to redirect_to(method[:data_url])
        end
      end
    end
  end

end
