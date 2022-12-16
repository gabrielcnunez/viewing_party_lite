class MoviesController < ApplicationController
  before_action :find_user

  def index
    conn = Faraday.new(url: 'https://api.themoviedb.org/3/') do |faraday|
      faraday.params["api_key"] = ENV["movie_api_key"]
    end
    
    if params[:search].present?
      response = conn.get("search/movie?query=#{params[:search]}")
      json = JSON.parse(response.body, symbolize_names: true)
      @movies = json[:results][0..19].map do |movie_data|
        Movie.new(movie_data)
      end
    else
      response = conn.get("movie/top_rated")
      json = JSON.parse(response.body, symbolize_names: true)
      @movies = json[:results][0..19].map do |movie_data|
        Movie.new(movie_data)
      end
    end
  end

  def show
    movie_id = params[:id]
    conn = Faraday.new(url: 'https://api.themoviedb.org/3') do |faraday|
      faraday.params['api_key'] = ENV['movie_api_key']
    end

    response = conn.get("movie/#{movie_id}")

    @movie = JSON.parse(response.body, symbolize_names: true)
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end
end
