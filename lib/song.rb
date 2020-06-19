class Song < ActiveRecord::Base
    has_many :playlist_songs
    has_many :playlists, through: :playlist_songs

    def beautify
        "#{self.artist} - #{self.name}"
    end

    def self.search_song_by_title(title) 
       results = RSpotify::Track.search(title, limit: 5, market: 'US') # find or create by
       # display to user
       self.display_results(results)
       # song stores spotify_id, title, artist_name
       # associate to user
    end

    
       
    def self.display_results(tracks)
        tracks.each_with_index do |track, index|
            puts "#{index + 1}. #{track.name} - #{track.artists[0].name}"
        end
        return true
    end

    # def display_options(results)
    #     i = 1
    #     results.each do |result|
    #        puts "#{i}. #{song[0].name} - #{track[0].artists[0].name} (#{track[0].album.name})"
    #        i += 1 
    #     end
        
    # end

    def self.add_song_to_playlist(song, playlist)

    end

    def self.open_song_in_web(song)
        if song
            Launchy.open("https://open.spotify.com/track/#{song[0].id}")
            return true
        else
            return false
        end
    end

    def save(song)
        Song.create()
    end

end