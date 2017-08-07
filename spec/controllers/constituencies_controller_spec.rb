require 'rails_helper'

RSpec.describe ConstituenciesController, vcr: true do

  describe 'GET index' do
    before(:each) do
      get :index
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @constituencies and @letters' do
      assigns(:constituencies).each do |constituency|
        expect(constituency).to be_a(Grom::Node)
        expect(constituency.type).to eq('http://id.ukpds.org/schema/ConstituencyGroup')
      end

      expect(assigns(:letters)).to be_a(Array)
    end

    it 'assigns @constituencies in alphabetical order' do
      expect(assigns(:constituencies)[0].name).to eq('constituencyGroupName - 1')
      expect(assigns(:constituencies)[1].name).to eq('constituencyGroupName - 10')
    end

    it 'renders the index template' do
      expect(response).to render_template('index')
    end
  end

  describe 'GET letters' do
    context 'returns a response' do
      before(:each) do
        get :letters, params: { letter: 'a' }
      end

      it 'should have a response with http status ok (200)' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @constituencies and @letters' do
        assigns(:constituencies).each do |constituency|
          expect(constituency).to be_a(Grom::Node)
          expect(constituency.type).to eq('http://id.ukpds.org/schema/ConstituencyGroup')
        end

        expect(assigns(:letters)).to be_a(Array)
      end

      it 'assigns @constituencies in alphabetical order' do
        expect(assigns(:constituencies)[0].name).to eq('constituencyGroupName - 1')
        expect(assigns(:constituencies)[1].name).to eq('constituencyGroupName - 10')
      end

      it 'renders the letters template' do
        expect(response).to render_template('letters')
      end
    end

    context 'does not return a response ' do
      before(:each) do
        get :letters, params: { letter: 'z' }
      end

      it 'returns a 200 response ' do
        expect(response).to have_http_status(200)
      end

      it 'assigns @constituencies as an empty array' do
        expect(controller.instance_variable_get(:@constituencies)).to be_empty
      end
    end
  end

  describe 'GET current_letters' do
    context 'returns a response ' do
      before(:each) do
        get :current_letters, params: { letter: 'a' }
      end

      it 'should have a response with http status ok (200)' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @constituencies and @letters' do
        assigns(:constituencies).each do |constituency|
          expect(constituency).to be_a(Grom::Node)
          expect(constituency.type).to eq('http://id.ukpds.org/schema/ConstituencyGroup')
        end

        expect(assigns(:letters)).to be_a(Array)
      end

      it 'assigns @constituencies in alphabetical order' do
        expect(assigns(:constituencies)[0].name).to eq('constituencyGroupName - 1')
        expect(assigns(:constituencies)[1].name).to eq('constituencyGroupName - 10')
      end

      it 'renders the current_letters template' do
        expect(response).to render_template('current_letters')
      end
    end

    context 'does not return a response ' do
      before(:each) do
        get :letters, params: { letter: 'z' }
      end

      it 'returns a 200 response ' do
        expect(response).to have_http_status(200)
      end

      it 'assigns @constituencies as an empty array' do
        expect(controller.instance_variable_get(:@constituencies)).to be_empty
      end
    end
  end

  describe "GET a_to_z" do
    before(:each) do
      get :a_to_z
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @letters' do
      expect(assigns(:letters)).to be_a(Array)
    end

    it 'renders the a_to_z template' do
      expect(response).to render_template('a_to_z')
    end
  end

  describe "GET a_to_z_current" do
    before(:each) do
      get :a_to_z_current
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @letters' do
      expect(assigns(:letters)).to be_a(Array)
    end

    it 'renders the a_to_z_current template' do
      expect(response).to render_template('a_to_z_current')
    end
  end

  describe 'GET lookup_by_letters' do
    context 'it returns multiple results' do
      before(:each) do
        get :lookup_by_letters, params: { letters: 'hove' }
      end

      it 'should have a response with http status ok (200)' do
        expect(response).to have_http_status(200)
      end

      it 'assigns @constituencies and @letters' do
        assigns(:constituencies).each do |constituency|
          expect(constituency).to be_a(Grom::Node)
          expect(constituency.type).to eq('http://id.ukpds.org/schema/ConstituencyGroup')
        end

        expect(assigns(:letters)).to be_a(Array)
      end

      it 'renders the lookup_by_letters template' do
        expect(response).to render_template('lookup_by_letters')
      end
    end

    context 'it returns a single result' do
      before(:each) do
        get :lookup_by_letters, params: { letters: 'hove' }
      end

      it 'should have a response with http status redirect (302)' do
        expect(response).to have_http_status(302)
      end

      it 'redirects to constituencies/:id' do
        expect(response).to redirect_to(constituency_path('JGl1V427'))
      end
    end
  end

  describe '#data_check' do
    context 'an available data format is requested' do
      METHODS = [
        {
          route: 'index',
          data_url: "#{ENV['PARLIAMENT_BASE_URL']}/constituency_index"
        },
        {
          route: 'lookup_by_letters',
          parameters: { letters: 'epping' },
          data_url: "#{ENV['PARLIAMENT_BASE_URL']}/constituency_by_substring?substring=epping"
        },
        {
          route: 'a_to_z_current',
          data_url: "#{ENV['PARLIAMENT_BASE_URL']}/constituency_current_a_to_z"
        },
        {
          route: 'current',
          data_url: "#{ENV['PARLIAMENT_BASE_URL']}/constituency_current"
        },
        {
          route: 'letters',
          parameters: { letter: 'p' },
          data_url: "#{ENV['PARLIAMENT_BASE_URL']}/constituency_by_initial?initial=p"
        },
        {
          route: 'current_letters',
          parameters: { letter: 'p' },
          data_url: "#{ENV['PARLIAMENT_BASE_URL']}/constituency_current_by_initial?initial=p"
        },
        {
          route: 'a_to_z',
          data_url: "#{ENV['PARLIAMENT_BASE_URL']}/constituency_a_to_z"
        },
      ]

      before(:each) do
        headers = { 'Accept' => 'application/rdf+xml' }
        request.headers.merge(headers)
      end

      it 'should have a response with http status redirect (302)' do
        METHODS.each do |method|
          if method.include?(:parameters)
            get method[:route].to_sym, params: method[:parameters]
          else
            get method[:route].to_sym
          end
          expect(response).to have_http_status(302)
        end
      end

      it 'redirects to the data service' do
        METHODS.each do |method|
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
        headers = { 'Accept' => 'application/n-quads' }
        request.headers.merge(headers)
      end

      it 'should raise ActionController::UnknownFormat error' do
        expect{ get :index }.to raise_error(ActionController::UnknownFormat)
      end
    end
  end
  
end
