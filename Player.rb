class Player
    attr_reader :name

    def initialize(name)
        @name = name
    end

    def guess
        print "Enter the char : "
        gets.chomp
    end

    def self.alert_invalid_guess(ch)
        puts "#{ch} isn't a valid move"
        puts "Your char must be a letter of the alphabit"
        puts "Your fragment must be a start of an real word "
    end
end
# 
