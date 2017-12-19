class ArticlesController < ApplicationController
  before_action :data_check, :build_request, :disable_top_navigation

  ROUTE_MAP = {
    index: proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.webarticles_index },
  }.freeze

  def index
    @articles = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'WebArticle')
  end
end
