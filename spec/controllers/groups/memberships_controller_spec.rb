require 'rails_helper'

RSpec.describe Groups::MembershipsController, vcr: true do
  describe 'GET index' do
    before(:each) do
      get :index, params: { group_id: 'P7Ne09WK' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @group' do
      expect(assigns(:group)).to be_a(Grom::Node)
      expect(assigns(:group).type).to eq(['https://id.parliament.uk/schema/Group', 'https://id.parliament.uk/schema/FormalBody'])
    end

    it 'assigns @formal_body_chair_members' do
      assigns(:formal_body_chair_members).each do |member|
        expect(member).to be_a(Grom::Node)
        expect(member.type).to eq('https://id.parliament.uk/schema/Person')
      end
    end

    it 'assigns @people' do
      assigns(:people).each do |person|
        expect(person).to be_a(Grom::Node)
        expect(person.type).to eq('https://id.parliament.uk/schema/Person')
      end
    end

    it 'assigns @non_chair_members' do
      assigns(:non_chair_members).each do |member|
        expect(member).to be_a(Grom::Node)
        expect(member.type).to eq('https://id.parliament.uk/schema/Person')
      end
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
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/group_members_current?group_id=P7Ne09WK"
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
