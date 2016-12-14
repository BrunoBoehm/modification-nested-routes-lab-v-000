class SongsController < ApplicationController

#           Prefix Verb   URI Pattern                                  Controller#Action
#     artist_songs GET    /artists/:artist_id/songs(.:format)          songs#index
#  new_artist_song GET    /artists/:artist_id/songs/new(.:format)      songs#new
# edit_artist_song GET    /artists/:artist_id/songs/:id/edit(.:format) songs#edit
#      artist_song GET    /artists/:artist_id/songs/:id(.:format)      songs#show


  def index
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      if @artist.nil?
        redirect_to artists_path, alert: "Artist not found"
      else
        @songs = @artist.songs
      end
    else
      @songs = Song.all
    end
  end

  def show
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      @song = @artist.songs.find_by(id: params[:id])
      if @song.nil?
        redirect_to artist_songs_path(@artist), alert: "Song not found"
      end
    else
      @song = Song.find(params[:id])
    end
  end

  def new
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      if @artist.nil?
        redirect_to artists_path, alert: "Song not found"
      else
        @song = @artist.songs.build
      end
    else
      @song = Song.new
    end
  end

  def create
    @song = Song.new(song_params)
    if @song.save
      redirect_to @song
    else
      render :new
    end
  end

  def edit
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      @song = Song.find_by(id: params[:id])
      if @artist.nil?
        redirect_to artists_path
      elsif @song.nil?
        redirect_to artist_songs_path(@artist)
      else
        @song = Song.find(params[:id])
      end
    else
      @song = Song.find(params[:id])
    end
  end

  def update
    @song = Song.find(params[:id])

    @song.update(song_params)

    if @song.save
      redirect_to @song
    else
      render :edit
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    flash[:notice] = "Song deleted."
    redirect_to songs_path
  end

  private

  def song_params
    params.require(:song).permit(:title, :artist_name, :artist_id)
  end
end

