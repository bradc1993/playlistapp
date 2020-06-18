class User < ActiveRecord::Base
    has_many :playlists

    def self.view_all_playlists
        Playlist.all
    end

    def self.view_all_songs_on_all_playlists
        results = Playlist.all.map do |pl|
            pl.songs.map do |s|
                s.beautify
            end
        end
        results.uniq(&:first)
    end

    def add_song_to_playlist(song, chosen_playlist)
        added_song = Song.find_or_create_by(name: "#{song[0].name}", artist: "#{song[0].artists[0].name}", genre: "#{song.genre}")
        chosen_playlist.songs << added_song
    end

    def delete_song_from_playlist(song, chosen_playlist)
    end

    def confirm_selection
        # ask user if this is the correct result
        # if not, index += 1
    end

    def view_all_songs_by_artist(artist)
    end

    def view_all_songs_in_genre(genre)
    end

end