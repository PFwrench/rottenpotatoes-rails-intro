class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.get_ratings()

    redirect = false
    if params[:ratings] == nil
      if session[:ratings] == nil
        @current_ratings = []
      else
        redirect = true
        @current_ratings = session[:ratings]
      end
    else
      @current_ratings = params[:ratings]
    end

    if params[:sorted] == nil
      if session[:sorted] != nil
        redirect = true
      end
      @sorted = session[:sorted]
    else
      @sorted = params[:sorted]
    end

    if redirect
      puts "SHOULD REDIRECT HERE"
      # redirect_to controller: "movies", sorted: @sorted
      redirect_to controller: "movies", sorted: @sorted, ratings: @current_ratings
      return
    end
  
    if @sorted == "title"
      @movies = Movie.with_ratings(@current_ratings).sort_by(&:title)
      puts "Sorted by title possibly"
    elsif @sorted == "release_date"
      @movies = Movie.with_ratings(@current_ratings).sort_by(&:release_date)
      puts "Sorted by date possibly"
    else
      @movies = Movie.with_ratings(@current_ratings)
    end

    session[:sorted] = @sorted
    session[:ratings] = @current_ratings

    puts session[:sorted] == nil
    puts session[:ratings] == nil
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
