require 'rails_helper'

RSpec.describe ArticlesController, vcr: true do

  describe 'GET index' do
    before(:each) do
      get :index
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @articles' do
      assigns(:articles).each do |article|
        expect(article).to be_a(Grom::Node)
        expect(article.type).to eq('https://id.parliament.uk/schema/WebArticle')
      end
    end

    it 'renders the index template' do
      expect(response).to render_template('index')
    end
  end
end
