require "colorize"
require "tty-prompt"

class CommandLineInterface

    current_username = ""

    def menu
        welcome
        login_or_sign_up
        display_main_menu
    end
    
    def welcome
        puts "\n---------------------------".green.bold
        puts "WELCOME TO THE PLAYLIST APP".green.bold
        puts "---------------------------".green.bold
        sleep(2)
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

        User.create(username: username, password: password)

        current_username = username

        puts "\n---------------------------".green
        puts "\nWELCOME, #{username}!".green.bold
        sleep(2)
    end

    def get_username_and_password
        print "\nPlease enter your username: ".green
        username = gets.chomp
        current_username = username

        if User.find_by(username: username) != nil
            password = TTY::Prompt.new
            password = password.mask("Please enter your password:".green)
            sleep(1)

            if User.find_by(username: username, password: password) != nil
                puts "\n---------------------------".green
                puts "\nWELCOME BACK, #{username}!".green.bold
                sleep(2)

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

        sleep(2)

        puts "\n1. Create new playlist".green
        puts "2. View my playlists".green
        puts "3. Log out".green

        print "\nEnter a number: ".green.bold
        response = gets.chomp

        # stretch goal: 4. Add song to another user's queue
        if response == "1"
            display_create_playlist_menu
        elsif response == "2"
            # insert method here: view_user_playlists
            puts "test"
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
        song_artist = results[number - 1].artists[0].name

        puts "You choose #{song_name.upcase} by #{song_artist.upcase}"
        puts "If this is correct, please enter 'add'"
        puts "Otherwise, press enter to search again"
        print "Response: "
        response = gets.chomp

        if response == "add"
            playlist.songs << Song.new(name: song_name, artist: song_artist)
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
        elsif response == "search"
            add_song_to_playlist_menu(playlist)
        else
            "please learn to read"
        end
    end

    def display_view_playlist_menu
    end
end