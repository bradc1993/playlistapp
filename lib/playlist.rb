class Playlist < ActiveRecord::Base
    has_many :playlist_songs
    has_many :songs, through: :playlist_songs
    has_many :user_playlists
    has_many :users, through: :user_playlists

    def self.create_new_playlist(name, description)
        Playlist.new(name: name, description: description)
    end

end