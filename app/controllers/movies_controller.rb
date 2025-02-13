class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
  
  def all_ratings
    hash = {}
    Movie.all_ratings.each { |val| hash[val] = '1' }
    hash
  end
  
  def with_ratings
    @ratings
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sort = params[:sort] || session[:sort]
    @ratings = params[:ratings] || session[:ratings] || all_ratings
    @with_ratings = Movie.with_ratings(@ratings)
    @movies = @with_ratings.order(@sort)
    @all_ratings = Movie.all_ratings
    
    session[:sort], session[:ratings] = @sort, @ratings
    
    if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
      flash.keep
      redirect_to movies_path sort: @sort, ratings: @ratings
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
