require "colorize"
require "tty-prompt"
require "pry"

class CommandLineInterface

    attr_accessor :current_user

    @current_user = nil

    def menu
        clear_screen
        welcome
        login_or_sign_up
        display_main_menu
    end

    def clear_screen
        system("clear")
    end
    
    def welcome
        display_banner("welcome to the playlist app!")
    end

#########################################################
#       USER AUTHENTICATION                             #
#########################################################

    def login_or_sign_up
        print "\nHave you used the app before? (enter: 'y' or 'n') ".green
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

######################
# create a new account
######################

    def create_new_account

        clear_screen
        welcome
        
        print "\nPlease enter a username: ".green
        username = gets.chomp

        if User.find_by(username: username)
            puts "\nSORRY! THAT USERNAME HAS ALREADY BEEN TAKEN. TRY BEING MORE ORIGINAL.".red.bold
            
            sleep(5)

            create_new_account
        end

        flag = true
        while flag
            password = TTY::Prompt.new
            password = password.mask("Enter your password:".green)
            password_confirmation = TTY::Prompt.new
            password_confirmation = password_confirmation.mask("Confirm your password:".green)

            if password == password_confirmation
                flag = false
            else
                clear_screen
                welcome

                puts "\nYour passwords didn't match. Try again but stay focused this time.".red.bold
            end
        end

        @current_user = User.create(username: username, password: password)

        clear_screen
        display_banner("welcome, #{@current_user.username}!")
    end

####################################
# sign in if account already created
####################################

    def get_username_and_password

        clear_screen
        welcome

        print "\nEnter your username: ".green
        username = gets.chomp


        if User.find_by(username: username) != nil
            password = TTY::Prompt.new
            password = password.mask("Enter your password:".green)

            if User.find_by(username: username, password: password) != nil

                @current_user = User.find_by(username: username)

                clear_screen
                display_banner("welcome back, #{username.upcase}!")

                sleep(2)

                display_main_menu
            else
                puts "Password incorrect, please try again".red
                get_username_and_password
            end

        else

            clear_screen
            welcome

            puts "\nUsername not found, please try again".red.bold
            print "\nWould you like to try creating a new account? (y/n) :".green
            response = gets.chomp

            if response == "y"
                create_new_account
            elsif response == "n"
                get_username_and_password
            else
                "Input not recognized. Please enter 'y' or 'n'".red
                get_username_and_password
            end
        end
    end

#########################################################
#       MENU DISPLAYS                                   #
#########################################################

###########
# main menu
###########

    def display_main_menu
        puts "\nWhat would you like to do?".green.bold

        sleep(2)

        puts "\n1. Create new playlist".green
        puts "2. View my playlists".green
        puts "3. Log out".green

        print "\nEnter a number: ".green.bold
        response = gets.chomp

        if response == "1"
            display_create_playlist_menu
        elsif response == "2"
            if @current_user.playlists.length > 0
                display_view_playlists
            else
                clear_screen
                puts "\nYou don't have any playlists yet!".red.bold
                sleep(2)
                display_main_menu
            end
        elsif response == "3"
            # insert method here: log_out
            puts "test"
        else
            puts "\nResponse not recognized. Please try again.\n".red
            display_main_menu
        end
    end

#######################
# create a new playlist
#######################

    def display_create_playlist_menu

        clear_screen
        display_banner("Enter a name and description for your playlist:")

        sleep(3)

        print "\nPlaylist Name: ".green
        playlist_name = gets.chomp
        print "\nPlaylist Description: ".green
        playlist_description = gets.chomp

        new_playlist = Playlist.create_new_playlist(playlist_name, playlist_description)

        add_song_to_playlist_menu(new_playlist)
    end

##############################
# add a new song to a playlist
##############################

    def add_song_to_playlist_menu(playlist)

        clear_screen
        
        display_banner("enter a song you would like to add to { #{playlist.name.upcase} }")

        print "\nEnter a song by name: ".green
        song_search = gets.chomp

        results = Song.search_song_by_title(song_search)

        clear_screen

        display_banner("top search results")
        
        results.each_with_index do |track, index|
            sleep(1)
            puts "#{index + 1}. #{track.name} - #{track.artists[0].name}".yellow
        end

        sleep(1)

        print "\nEnter a number to add a song to #{playlist.name.upcase} or enter the number '0' to search again: ".green
        number = gets.chomp.to_i

        if number == 0
            add_song_to_playlist_menu(playlist)
        end

        song_name = results[number-1].name
        song_artist = results[number-1].artists[0].name
        song_spotify_id = results[number-1].id

        clear_screen

        display_banner("You chose { #{song_name.upcase} by #{song_artist.upcase} }")

        sleep(2)

        print "\nType 'add' to save this song to #{playlist.name.upcase} or press enter to search again: ".green
        response = gets.chomp

        if response == "add"
            song = Song.find_by(name: song_name, artist: song_artist)
            if song 
                playlist.songs << song
            else
                playlist.songs << Song.new(name: song_name, artist: song_artist, spotify_id: song_spotify_id)
            end
        else
            clear_screen
            add_song_to_playlist_menu(playlist)
        end

        clear_screen

        display_banner("You just added { #{song_name.upcase} } to your playlist { #{playlist.name.upcase} }")

        sleep(4)

        clear_screen

        display_banner("Updated track list for #{playlist.name.upcase}: ")

        sleep(2)

        playlist.songs.each_with_index do |song, index|
            puts "#{index + 1}. #{song.name} by #{song.artist}".yellow
            sleep(1)
        end

        puts "\nWould you like to 'save' this playlist or 'add' another song?".green

        print "\nEnter 'save' or 'add': ".green.bold
        response = gets.chomp

        if response == "save"
            if @current_user.playlists.include? playlist
                playlist.save
                clear_screen
                display_banner("{ #{playlist.name.upcase} } has been updated!")
            else
                @current_user.playlists << playlist
                clear_screen
                display_banner("{ #{playlist.name.upcase} } has been saved to your playlists!")
            end

            sleep(3)
            clear_screen
            welcome
            display_main_menu

        elsif response == "add"
            clear_screen
            add_song_to_playlist_menu(playlist)
        else
            "please learn to read"
        end
    end

###########################
# display created playlists
###########################

    def display_view_playlists

        clear_screen

        display_banner("playlists created by #{@current_user.username.upcase}: ")


        @current_user.playlists.each_with_index do |playlist, index|
            puts "\n#{index + 1}. #{playlist.name} - #{playlist.description}".yellow
        end

        print "\nSelect a playlist by entering the corresponding number: ".green
        response = gets.chomp.to_i

        selected_playlist = @current_user.playlists[response-1]

        clear_screen

        display_banner("#{selected_playlist.name.upcase} TRACK LIST:")

        sleep(1)

        selected_playlist.songs.each_with_index do |song, index|
            puts "#{index + 1}. #{song.name} by #{song.artist}".yellow
            sleep(1)
        end

        puts "\nWhat would you like to do?".green.bold

        sleep(1)

        puts "\n1. Add song to #{selected_playlist.name.upcase}".green
        puts "2. Listen to a song on #{selected_playlist.name.upcase}".green
        print "\nEnter a number: ".green.bold
        response = gets.chomp

        if response == "1"
            clear_screen
            add_song_to_playlist_menu(selected_playlist)

        elsif response == "2"
            clear_screen
            display_banner("which song would you like to play?")

            selected_playlist.songs.each_with_index do |song, index|
                puts "#{index + 1}. #{song.name} by #{song.artist}".yellow
            end

            print "\nEnter a number:".green.bold
            new_response = gets.chomp.to_i
            Song.open_song_in_web(selected_playlist.songs[new_response-1])

            clear_screen
            welcome
            display_main_menu
        else
            "response not recognized, please try again"
        end

    end

##################################
# DISPLAY BANNERS                #
##################################

    def display_banner(text)
        puts ("-" * text.length).green.bold
        puts text.upcase.green.bold
        puts ("-" * text.length).green.bold
    end

end