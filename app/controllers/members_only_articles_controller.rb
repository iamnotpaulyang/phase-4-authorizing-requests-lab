class MembersOnlyArticlesController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
before_action :authorize

  def index
    articles = Article.where(is_member_only: true).includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
    # articles = Article.all
    # render json: articles
    #render json: Article.all, status: :ok
  end

  def show
    article = Article.find(params[:id])
    render json: article
  end

  private

  def authorize
    return render json: { error: "Not authorized" }, status: :unauthorized unless session.include? :user_id
  end
  
  def record_not_found
    render json: {error: "Not found"}, status: 404
  end

end
