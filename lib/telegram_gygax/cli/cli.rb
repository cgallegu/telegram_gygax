require 'telegram_gygax/game'

module TelegramGygax
    class Cli
        def initialize
            @game = TelegramGygax::Game.new
        end

        def self.start
            game = TelegramGygax::Game.new
            puts game.act 'look'
            
            while true
                input = gets.chomp.strip
                break if input == 'exit'
                puts game.act input
            end 
            puts "Farewell."
        end
    end
end
