class MoviesController < ApplicationController
  before_action :set_movie, only: %i[ show edit update destroy ]

  # GET /movies or /movies.json
  def index
    session[:sort_column] = params[:sort] if params[:sort].present?
    session[:sort_direction] = params[:direction] if params[:direction].present?
    @sort_column = session[:sort_column] || 'title' #default param is to sort to title
    @sort_direction = session[:sort_direction] || 'asc' #default param for direction is to sort ascending order

    session[:sort_column] = @sort_column

    @movies = Movie.order("#{@sort_column} #{@sort_direction}")

  end

  # GET /movies/1 or /movies/1.json
  def show
    @sort_column = session[:sort_column] 
    @sort_direction = session[:sort_direction] 
  end

  # GET /movies/new
  def new
    @movie = Movie.new
    @sort_column = session[:sort_column] 
    @sort_direction = session[:sort_direction] 
  end

  # GET /movies/1/edit
  def edit
    @sort_column = session[:sort_column] 
    @sort_direction = session[:sort_direction] 
  end

  # POST /movies or /movies.json
  def create
    @movie = Movie.new(movie_params)
    @sort_column = session[:sort_column] 
    @sort_direction = session[:sort_direction] 
    respond_to do |format|
      if @movie.save
        format.html { redirect_to movie_path(sort: @sort_column, direction: @sort_direction), notice: "Movie was successfully created." }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1 or /movies/1.json
  def update
    @sort_column = session[:sort_column] 
    @sort_direction = session[:sort_direction] 
    
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to movie_path(sort: @sort_column, direction: @sort_direction), notice: "Movie was successfully updated." }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1 or /movies/1.json
  def destroy
    @movie.destroy!
    @sort_column = session[:sort_column] 
    @sort_direction = session[:sort_direction] 
    respond_to do |format|
      format.html { redirect_to movie_path(sort: @sort_column, direction: @sort_direction), notice: "Movie was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
end
