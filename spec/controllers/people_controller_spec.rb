require 'rails_helper'

RSpec.describe PeopleController, vcr: true do

  describe 'GET index' do
    before(:each) do
      get :index
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @people in alphabetical order' do
      expect(assigns(:people)[0].given_name).to eq('personGivenName - 1')
      expect(assigns(:people)[1].given_name).to eq('personGivenName - 10')
    end

    it 'renders the index template' do
      expect(response).to render_template('index')
    end
  end

  describe 'GET letters' do
    context 'there is a response' do
      before(:each) do
        get :letters, params: { letter: 't' }
      end

      it 'should have a response with http status ok (200)' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @people and @letters' do
        assigns(:people).each do |person|
          expect(person).to be_a(Grom::Node)
          expect(person.type).to eq('http://id.ukpds.org/schema/Person')
        end

        expect(assigns(:letters)).to be_a(Array)
      end

      it 'assigns @people in alphabetical order' do
        expect(assigns(:people)[0].given_name).to eq('personGivenName - 1')
        expect(assigns(:people)[1].given_name).to eq('personGivenName - 10')
      end

      it 'renders the letters template' do
        expect(response).to render_template('letters')
      end
    end

    context 'there is no response' do
      before(:each) do
        get :letters, params: { letter: 'x' }
      end

      it 'http status of 200' do
        expect(response).to have_http_status(200)
      end

      it 'has a blank @people array' do
        expect(controller.instance_variable_get(:@people)).to be_empty
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

  describe 'GET lookup_by_letters' do
    context 'it returns multiple results' do
      before(:each) do
        get :lookup_by_letters, params: { letters: 'cam' }
      end

      it 'should have a response with http status ok (200)' do
        expect(response).to have_http_status(200)
      end

      it 'assigns @people and @letters' do
        assigns(:people).each do |person|
          expect(person).to be_a(Grom::Node)
          expect(person.type).to eq('http://id.ukpds.org/schema/Person')
        end

        expect(assigns(:letters)).to be_a(Array)
      end

      it 'renders the lookup_by_letters template' do
        expect(response).to render_template('lookup_by_letters')
      end
    end

    context 'it returns a single result' do
      before(:each) do
        get :lookup_by_letters, params: { letters: 'creasy' }
      end

      it 'should have a response with http status redirect (302)' do
        expect(response).to have_http_status(302)
      end

      it 'redirects to people/:id' do
        expect(response).to redirect_to(person_path('PjRtyVbi'))
      end
    end
  end

  describe '#data_check' do
    context 'an available data format is requested' do
      methods = [
          {
            route: 'index',
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/person_index"
          },
          {
            route: 'letters',
            parameters: { letter: 'l' },
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/person_by_initial?initial=l"
          },
          {
            route: 'a_to_z',
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/person_a_to_z"
          },
          {
            route: 'lookup_by_letters',
            parameters: { letters: 'creasy' },
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/person_by_substring?substring=creasy"
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
