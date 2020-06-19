class CommandLineInterface

    def menu
        welcome
        login_or_sign_up
        display_menu
    end
    
    def welcome
        puts "\nWelcome to the Playlist App!"
    end

    def login_or_sign_up
        print "Have you used the app before? y/n "
        response = gets.chomp
        if response == "y"
            get_username_and_password
        elsif response == "n"
            create_new_account
        else
            puts "\nResponse not recognized. Please try again.\n"
            login_or_sign_up
        end
    end

    def create_new_account
        print "Please enter a username: "
        username = gets.chomp
        print "Please enter a password: "
        password = gets.chomp
        User.create(username: username, password: password)
    end

    def get_username_and_password
        print "\nPlease enter your username: "
        username = gets.chomp
        print "Please enter your password: "
        password = gets.chomp
        User.find_by(username: username, password: password)
    end

    def display_menu
        puts "What would you like to do?"
        puts "\n1. Create new playlist"
        puts "2. View my playlists"
        puts "3. Log out"
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
            puts "\nResponse not recognized. Please try again.\n"
            display_menu
        end
    end


        



    


    

end