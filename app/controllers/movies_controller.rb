# in app/controllers/movies_controller.rb

class MoviesController < ApplicationController
  def index

    @all_ratings = Movie.ratings

    if session[:ratings]
      @ratings = session[:ratings]
      @movies = Movie.find_all_by_rating(@ratings)
    else
      @movies = Movie.all
    end

    if params[:ratings]
      session[:ratings] = params[:ratings].keys
      @ratings = session[:ratings]
      @movies = Movie.find_all_by_rating(@ratings)
    end

    if params[:sort_by] == 'movies'
      session[:sort_by] = 'movies'
    end

    if params[:sort_by] == 'release_date'
      session[:sort_by] = 'release_date'
    end
    
    if session[:sort_by] == 'movies'
      @movies.sort! { |a,b| a.title.downcase <=> b.title.downcase }
      @sort_by_movie = true
      @sort_by_release_date = false
    end

    if session[:sort_by] == 'release_date'
      @movies = Movie.find(:all, order: 'release_date')
      @movies = Movie.find_all_by_rating(@ratings)
      @sort_by_release_date = true
      @sort_by_movie = false
    end

  end

  def show
    id = params[:id]
    @movie = Movie.find(id)
    # will render app/views/movies/show.html.haml by default
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
end
