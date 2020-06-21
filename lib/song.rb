class Song < ActiveRecord::Base
    has_many :playlist_songs
    has_many :playlists, through: :playlist_songs


    def self.search_song_by_title(title) 
       results = RSpotify::Track.search(title, limit: 5, market: 'US')
       results
    end 

    def self.search_songs_by_artist(artist) 
        results = RSpotify::Artist.search(artist)[0].top_tracks('US')
        results
     end 
       
    def self.display_results(tracks)
        tracks.each_with_index do |track, index|
            puts "#{index + 1}. #{track.name} - #{track.artists[0].name}"
        end
        return true
    end

    def self.open_song_in_web(song)
        if song
            Launchy.open("https://open.spotify.com/track/#{song.spotify_id}")
            return true
        else
            return false
        end
    end

end