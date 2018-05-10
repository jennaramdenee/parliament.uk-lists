require 'rails_helper'

RSpec.describe ProceduresController, vcr: true do
  describe 'GET index' do
    before(:each) do
      get :index
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @procedures' do
      expect(assigns(:procedures).first).to be_a(Grom::Node)
      expect(assigns(:procedures).first.type).to eq('https://id.parliament.uk/schema/Procedure')
    end

    it 'renders the index template' do
      expect(response).to render_template('index')
    end
  end

  describe '#data_check' do
    let(:data_check_methods) do
      [
        {
          route: 'index',
          data_url: "#{ENV['PARLIAMENT_BASE_URL']}/procedure_index"
        }
      ]
    end

    context 'an available data format is requested' do
      before(:each) do
        headers = { 'Accept' => 'application/rdf+xml' }
        request.headers.merge(headers)
      end

      it 'should have a response with http status redirect (302)' do
        data_check_methods.each do |method|
          if method.include?(:parameters)
            get method[:route].to_sym, params: method[:parameters]
          else
            get method[:route].to_sym
          end
          expect(response).to have_http_status(302)
        end
      end

      it 'redirects to the data service' do
        data_check_methods.each do |method|
          if method.include?(:parameters)
            get method[:route].to_sym, params: method[:parameters]
          else
            get method[:route].to_sym
          end
          expect(response).to redirect_to(method[:data_url])
        end
      end
    end

    context 'an unavailable data format is requested' do
      before(:each) do
        headers = { 'Accept' => 'application/foo' }
        request.headers.merge(headers)
      end
      it 'should raise ActionController::UnknownFormat error' do
        expect{ get :index, params: { article_id: 'H5YJQsK2' } }.to raise_error(ActionController::UnknownFormat)
      end
    end
  end
end
