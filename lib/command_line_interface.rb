require "colorize"
require "tty-prompt"

class CommandLineInterface

    def menu
        welcome
        login_or_sign_up
        display_menu
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
        print "Please enter a username: ".green
        username = gets.chomp

        password = TTY::Prompt.new
        password = password.mask("Please enter your password:".green)

        User.create(username: username, password: password)


    end

    def get_username_and_password
        print "\nPlease enter your username: ".green
        username = gets.chomp

        if User.find_by(username: username) != nil
            password = TTY::Prompt.new
            password = password.mask("Please enter your password:".green)

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

    def display_menu
        puts "\nWhat would you like to do?".green

        sleep(2)
        
        puts "\n1. Create new playlist".green
        puts "2. View my playlists".green
        puts "3. Log out".green
        # stretch goal: 4. Add song to another user's queue
        response = gets.chomp
        if response == "1"
            # insert method here: create_new_playlist
            puts "test"
        elsif response == "2"
            # insert method here: view_user_playlists
            puts "test"
        elsif response == "3"
            # insert method here: log_out
            puts "test"
        else
            puts "\nResponse not recognized. Please try again.\n".red
            display_menu
        end
    end
end