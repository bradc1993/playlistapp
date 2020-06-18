class Song < ActiveRecord::Base
    has_many :playlist_songs
    has_many :playlists, through: :playlist_songs

    def beautify
        "#{self.artist} - #{self.name}"
    end

    def self.search_song_by_title(title)
        RSpotify::Track.search(title, limit: 1, market: 'US')
       # "#{song[0].name} - #{track[0].artists[0].name} (#{track[0].album.name})"
    end

    def self.add_song_to_playlist(song, playlist)

    end

end