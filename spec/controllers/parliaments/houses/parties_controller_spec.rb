require 'rails_helper'

RSpec.describe Parliaments::Houses::PartiesController, vcr: true do

  describe 'GET index' do
    before(:each) do
      get :index, params: { parliament_id: 'fHx6P1lb', house_id: 'Kz7ncmrt', member_count: 3 }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    context '@parliament' do
      it 'assigns @parliament' do
        expect(assigns(:parliament)).to be_a(Grom::Node)
        expect(assigns(:parliament).type).to eq('http://id.ukpds.org/schema/ParliamentPeriod')
      end
    end

    context '@house' do
      it 'assigns @house' do
        expect(assigns(:house)).to be_a(Grom::Node)
        expect(assigns(:house).type).to eq('http://id.ukpds.org/schema/House')
      end
    end

    context '@parties' do
      it 'assigns @parties' do
        assigns(:parties).each do |person|
          expect(person).to be_a(Grom::Node)
          expect(person.type).to eq('http://id.ukpds.org/schema/Party')
        end
      end

      it 'assigns @parties in alphabetical order' do
        expect(assigns(:parties)[0].name).to eq('partyName - 2')
        expect(assigns(:parties)[1].name).to eq('partyName - 1')
      end
    end

    it 'renders the house template' do
      expect(response).to render_template('index')
    end
  end

  describe '#data_check' do
    context 'an available data format is requested' do
      methods = [
        {
          route: 'index',
          parameters: { parliament_id: 'fHx6P1lb', house_id: 'Kz7ncmrt' },
          data_url: "#{ENV['PARLIAMENT_BASE_URL']}/parliament_house_parties?parliament_id=fHx6P1lb&house_id=Kz7ncmrt"
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
