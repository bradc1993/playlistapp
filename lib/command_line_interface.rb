require "colorize"
require "tty-prompt"
require "pry"

class CommandLineInterface

    attr_accessor :current_user

    @current_user = nil

    def menu
        welcome
        login_or_sign_up
        display_main_menu
    end

    def clear_screen
        system("clear")
    end
    
    def welcome
        puts "\n---------------------------".green.bold
        puts "WELCOME TO THE PLAYLIST APP".green.bold
        puts "---------------------------".green.bold
    end

    def login_or_sign_up
        print "\nHave you used the app before? y/n ".green
        response = gets.chomp
        if response == "y"
            get_username_and_password
        elsif response == "n"
            create_new_account
        else
            puts "\nResponse not recognized. Please try again.\n".red
            login_or_sign_up
        end
    end

    def create_new_account
        print "\nPlease enter a username: ".green
        username = gets.chomp

        password = TTY::Prompt.new
        password = password.mask("Please enter your password:".green)

        @current_user = User.create(username: username, password: password)

        puts "\n---------------------------".green
        puts "\nWELCOME, #{username}!".green.bold
    end

    def get_username_and_password
        print "\nPlease enter your username: ".green
        username = gets.chomp


        if User.find_by(username: username) != nil
            password = TTY::Prompt.new
            password = password.mask("Please enter your password:".green)

            if User.find_by(username: username, password: password) != nil

                @current_user = User.find_by(username: username)

                puts "\n---------------------------".green
                puts "\nWELCOME BACK, #{username}!".green.bold

            else
                puts "Password incorrect, please try again".red
                get_username_and_password
            end

        else
            puts "Username not found, please try again".red
            get_username_and_password
        end
    end

    def display_main_menu
        puts "\nWhat would you like to do?".green

        puts "\n1. Create new playlist".green
        puts "2. View my playlists".green
        puts "3. Log out".green

        print "\nEnter a number: ".green.bold
        response = gets.chomp

        if response == "1"
            display_create_playlist_menu
        elsif response == "2"
            display_view_playlists
        elsif response == "3"
            # insert method here: log_out
            puts "test"
        else
            puts "\nResponse not recognized. Please try again.\n".red
            display_main_menu
        end
    end

    def display_create_playlist_menu
        puts "Please enter a name and description for your playlist or enter 'm' for Main Menu"
        print "\nPlaylist Name: "
        playlist_name = gets.chomp
        print "\nPlaylist Description: "
        playlist_description = gets.chomp

        new_playlist = Playlist.create_new_playlist(playlist_name, playlist_description)

        add_song_to_playlist_menu(new_playlist)
    end

    def add_song_to_playlist_menu(playlist)
        puts "Please enter a song name you would like to add to #{playlist.name.upcase}"
        print "\nEnter a song name: "
        song_search = gets.chomp

        results = Song.search_song_by_title(song_search)
        Song.display_results(results)

        puts "Please enter a number to add a song to #{playlist.name.upcase} or enter 's' to search again"
        print "Enter a number: "
        number = gets.chomp.to_i

        song_name = results[number-1].name
        song_artist = results[number-1].artists[0].name
        song_spotify_id = results[number-1].id

        puts "You choose #{song_name.upcase} by #{song_artist.upcase}"
        puts "If this is correct, please enter 'add'"
        puts "Otherwise, press enter to search again"
        print "Response: "
        response = gets.chomp

        if response == "add"
            song = Song.find_by(name: song_name, artist: song_artist)
            if song 
                playlist.songs << song
            else
                playlist.songs << Song.new(name: song_name, artist: song_artist, spotify_id: song_spotify_id)
            end
        else
            add_song_to_playlist_menu(playlist)
        end

        puts "You just added #{song_name.upcase} to your playlist #{playlist.name.upcase}"
        puts "Here is your current playlist: "
        puts "#{playlist.name}: "
        playlist.songs.each do |song|
            puts song.name
        end

        puts "To save your playlist #{playlist.name.upcase}, please enter 'save'"
        puts "To add another song to your playlist #{playlist.name.upcase}, please enter 'search'"
        print "Response: "
        response = gets.chomp

        if response == "save"
            playlist.save
            @current_user.playlists << playlist

        elsif response == "search"
            add_song_to_playlist_menu(playlist)
        else
            "please learn to read"
        end
    end

    def display_view_playlists
        puts "Here are the playlists created by #{@current_user.username}"
        @current_user.playlists.each_with_index do |playlist, index|
            puts "#{index + 1}. #{playlist.name} - #{playlist.description}"
        end

        puts "Please select a playlist using the corresponding number"
        print "Enter a number: "
        response = gets.chomp.to_i

        selected_playlist = @current_user.playlists[response - 1]

        puts "Songs in #{selected_playlist.name}:"

        selected_playlist.songs.each_with_index do |song, index|
            puts "#{index + 1}. #{song.name} by #{song.artist}"
        end
    end
end