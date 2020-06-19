class Playlist < ActiveRecord::Base
    belongs_to :user
    has_many :playlist_songs
    has_many :songs, through: :playlist_songs

    def self.create_new_playlist(name, description)
        Playlist.new(name: name, description: description)
    end

end