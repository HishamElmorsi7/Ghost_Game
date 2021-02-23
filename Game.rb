require "set"
require_relative "Player.rb"
class Game
    attr_reader :losses, :players

    ALPHABETS = Set.new("a".."z")
    MAX_LOSS_COUNT = 5
    MIN_WORD_LENGTH = 4 
    
    def initialize(*players)
        @players = players
        @fragment = ""
        words = File.readlines("dictionary.txt").map(&:chomp)
        @dictionary = Set.new(words)
        @losses = Hash.new { |losses, player| losses[player] = 0}
    end

    def current_player
        @players.first
    end

    def next_player!
        @players.rotate!
        @players.rotate! until @losses[current_player] < MAX_LOSS_COUNT
    end

    def welcome
        system("cls")
        puts "----------------------"
        puts "Welcome to ghost game"
        puts "----------------------"
        puts "The rules of the game are:"
        puts "1- The word you make must be longer than 3 characters"
        puts "2- if anyone had the full letters of 'ghost', then he is eliminated"
        puts
    end

    def remaining_players
        @losses.values.count { |player_loss| player_loss < 5}
    end

    def game_over?
        remaining_players == 1
    end

    def set_players_losses
        @players.each {|player| losses[player]}
    end

    def valid_play?(str)
        return false if !ALPHABETS.include?(str.downcase)
        @dictionary.each { |word| return true if word.start_with?( (@fragment + str).downcase ) }
        false
    end

    def add_letter_to_fragment(letter)
        @fragment += letter
    end

    def is_word?
        @dictionary.include?(@fragment.downcase) 
    end

    def check_current_fragment
        if is_word? && @fragment.length >= MIN_WORD_LENGTH
            @losses[current_player] += 1
            next_player!
        else
            puts "current fragment is #{@fragment}"
            next_player!
        end
    end

    def take_turn
        puts "It's player #{current_player.name} turn"
        guessed_char = current_player.guess
        while !valid_play?(guessed_char)
            Player.alert_invalid_guess(guessed_char)
            print "Invalid input, Enter again: "
            guessed_char = gets.chomp
        end

        add_letter_to_fragment(guessed_char)
        check_current_fragment
        puts
    end

    def record(player)
        num_of_losses = @losses[player]
        if num_of_losses == 0
            puts "#{player.name}: #{''}"
        else
            puts "#{player.name}: #{"Ghost"[0..num_of_losses - 1]}"
        end
    end

    def round_over?
        is_word? && @fragment.length >= MIN_WORD_LENGTH
    end

    def display_standings
        puts "Current Standings :"
        @players.each { |player| record(player) }
    end

    def check_for_winner
        if remaining_players == 1
            puts "----------------------"
            @losses.values.each do |n_losses|
                puts "#{@losses.key(n_losses).name} is the winner ;" if n_losses < 5 
            end
            puts "Congratulations"
            puts "----------------------"
        end
    end

    def play_round
        puts "The current fragment is '' "
        puts
        set_players_losses
        take_turn until round_over?
        display_standings
        check_for_winner
        puts
    end

    def run
        welcome
        until game_over? do 
            @fragment = ""
            play_round
        end
   end
end

#Running the Game => Hisham Elmorsi
if $PROGRAM_NAME == __FILE__
    new_game = Game.new(Player.new("Hisham"), Player.new("Mohamed"), Player.new("Ramy"))
    new_game.run
end