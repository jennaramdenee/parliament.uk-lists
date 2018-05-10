require 'rails_helper'

RSpec.describe GroupsController, vcr: true do
  describe 'GET index' do
    before(:each) do
      get :index
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @groups and @letters' do
      assigns(:groups).each do |group|
        expect(group).to be_a(Grom::Node)
        expect(group.type).to eq('https://id.parliament.uk/schema/Group')
      end

      expect(assigns(:letters)).to be_a(Array)
    end

    it 'assigns @groups in alphabetical order' do
      expect(assigns(:groups)[0].name).to eq('groupName - 1')
      expect(assigns(:groups)[3].name).to eq('groupName - 10')
    end

    it 'renders the index template' do
      expect(response).to render_template('index')
    end
  end

  describe 'GET current' do
    before(:each) do
      get :current
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'should return the current number of groups' do
      expect(assigns(:groups).size).to eq(145)
    end

    it 'assigns @groups and @letters' do
      assigns(:groups).each do |group|
        expect(group).to be_a(Grom::Node)
        expect(group.type).to eq('https://id.parliament.uk/schema/Group')
      end

      expect(assigns(:letters)).to be_a(Array)
    end

    it 'assigns @groups in alphabetical order' do
      expect(assigns(:groups)[0].name).to eq('groupName - 1')
      expect(assigns(:groups)[1].name).to eq('groupName - 10')
    end

    it 'renders the current template' do
      expect(response).to render_template('current')
    end
  end

  describe 'GET letters' do
    context 'valid groups' do
      before(:each) do
        get :letters, params: { letter: 'd' }
      end

      it 'should have a response with http status ok (200)' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @groups and @letters' do
        assigns(:groups).each do |group|
          expect(group).to be_a(Grom::Node)
          expect(group.type).to eq('https://id.parliament.uk/schema/Group')
        end

        expect(assigns(:letters)).to be_a(Array)
      end

      it 'assigns @groups in alphabetical order' do
        expect(assigns(:groups)[0].name).to eq('groupName - 101')
        expect(assigns(:groups)[1].name).to eq('groupName - 110')
      end

      it 'renders the letters template' do
        expect(response).to render_template('letters')
      end
    end

    context 'invalid groups' do
      before(:each) do
        get :letters, params: { letter: 'x' }
      end

      it 'should return a 200 status' do
        expect(response).to have_http_status(200)
      end

      it 'should populate @groups with an empty array' do
        expect(controller.instance_variable_get(:@groups)).to be_empty
      end
    end
  end

  describe 'GET current_letters' do
    context 'valid groups' do
      before(:each) do
        get :current_letters, params: { letter: 'd' }
      end

      it 'should have a response with http status ok (200)' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @groups and @letters' do
        assigns(:groups).each do |group|
          expect(group).to be_a(Grom::Node)
          expect(group.type).to eq('https://id.parliament.uk/schema/Group')
        end

        expect(assigns(:letters)).to be_a(Array)
      end

      it 'assigns @groups in alphabetical order' do
        expect(assigns(:groups)[0].name).to eq('groupName - 110')
        expect(assigns(:groups)[1].name).to eq('groupName - 111')
      end

      it 'renders the current_letters template' do
        expect(response).to render_template('current_letters')
      end
    end

    context 'invalid groups' do
      before(:each) do
        get :letters, params: { letter: 'x' }
      end

      it 'should return a 200 status' do
        expect(response).to have_http_status(200)
      end

      it 'should populate @groups with an empty array' do
        expect(controller.instance_variable_get(:@groups)).to be_empty
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

    it 'renders the a_to_z template' do
      expect(response).to render_template('a_to_z_current')
    end
  end

  describe 'GET lookup_by_letters' do
    context 'it returns multiple results' do
      before(:each) do
        get :lookup_by_letters, params: { letters: 'dep' }
      end

      it 'should have a response with http status ok (200)' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @groups and @letters' do
        assigns(:groups).each do |group|
          expect(group).to be_a(Grom::Node)
          expect(group.type).to eq('https://id.parliament.uk/schema/Group')
        end

        expect(assigns(:letters)).to be_a(Array)
      end

      it 'renders the group template' do
        expect(response).to render_template('lookup_by_letters')
      end
    end

    context 'it returns a single result' do
      before(:each) do
        get :lookup_by_letters, params: { letters: 'york' }
      end

      it 'should have a response with http status redirect (302)' do
        expect(response).to have_http_status(302)
      end

      it 'redirects to groups/:id' do
        expect(response).to redirect_to(group_path('L2bKZqah'))
      end
    end
  end

  describe '#data_check' do
    context 'an available data format is requested' do
      methods = [
          {
            route: 'index',
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/group_index"
          },
          {
            route: 'current',
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/group_current"
          },
          {
            route: 'letters',
            parameters: { letter: 'l' },
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/group_by_initial?initial=l"
          },
          {
            route: 'current_letters',
            parameters: { letter: 'l' },
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/group_current_by_initial?initial=l"
          },
          {
            route: 'a_to_z',
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/group_a_to_z"
          },
          {
            route: 'a_to_z_current',
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/group_current_a_to_z"
          },
          {
            route: 'lookup_by_letters',
            parameters: { letters: 'labour' },
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/group_by_substring?substring=labour"
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
