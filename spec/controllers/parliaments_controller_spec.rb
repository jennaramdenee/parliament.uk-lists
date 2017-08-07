require 'rails_helper'

RSpec.describe ParliamentsController, vcr: true do
  describe "GET index" do
    before(:each) do
      get :index
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @parliaments' do
      assigns(:parliaments).each do |parliament|
        expect(parliament).to be_a(Grom::Node)
        expect(parliament.type).to eq('http://id.ukpds.org/schema/ParliamentPeriod')
      end
    end

    it 'assigns @parliaments in numeric order' do
      expect(assigns(:parliaments)[0].number).to eq(57)
      expect(assigns(:parliaments)[1].number).to eq(56)
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
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/parliament_index"
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
