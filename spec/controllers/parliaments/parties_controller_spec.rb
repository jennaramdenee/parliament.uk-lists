require 'rails_helper'

RSpec.describe Parliaments::PartiesController, vcr: true do

  describe 'GET index' do
    before(:each) do
      get :index, params: { parliament_id: 'fHx6P1lb' }
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

    context '@parties' do
      it 'assigns @parties' do
        assigns(:parties).each do |party|
          expect(party).to be_a(Grom::Node)
          expect(party.type).to eq('http://id.ukpds.org/schema/Party')
        end
      end

      it 'assigns @parties in member count then name order' do
        expect(assigns(:parties)[0].name).to eq('partyName - 2')
        expect(assigns(:parties)[0].member_count).to eq(309)
        expect(assigns(:parties)[1].name).to eq('partyName - 14')
        expect(assigns(:parties)[1].member_count).to eq(273)
        expect(assigns(:parties)[10].name).to eq('partyName - 10')
        expect(assigns(:parties)[10].member_count).to eq(1)
        expect(assigns(:parties)[11].name).to eq('partyName - 12')
        expect(assigns(:parties)[11].member_count).to eq(1)
        expect(assigns(:parties)[12].name).to eq('partyName - 5')
        expect(assigns(:parties)[12].member_count).to eq(1)
      end
    end

    it 'renders the parties template' do
      expect(response).to render_template('index')
    end
  end

  describe '#data_check' do
    context 'an available data format is requested' do
      methods = [
          {
            route: 'index',
            parameters: { parliament_id: 'fHx6P1lb' },
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/parliament_parties?parliament_id=fHx6P1lb"
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
