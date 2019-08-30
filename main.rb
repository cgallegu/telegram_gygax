require 'telegram/bot'
require 'logger'

module Gygax
    # Models what the player can interact with directly
    # See what can be pulled to a module/base class so that only
    # defining the room specific data/logic is required
    class InfiniteEmptyRoom
        attr_reader :exits
        def initialize
            @exits = {
                'north' => :room
            }
            @times_visited = 0
        end
        def self.id
            :room
        end

        def describe
            'An empty room.'
        end

        def look noun
            message = case @times_visited
            when 0
                noun ? "You look #{noun}, and it looks pretty normal" : 'This room looks empty'
            when 1
                noun ? "Looking #{noun} you feel a strange sense of deja vu" : 'This room looks familiar' 
            else
                "Looks like you've been here #{@times_visited} times before"
            end

            exits = @exits.keys
            exit_message = case exits.length
            when 1
                "The only way out is #{exits.first}"
            else
                last = exits.pop
                "You can see exits #{@exits.join ','} and #{last}"
            end

            "#{message}\n#{exit_message}"
        end

        def has_exit? direction
            @exits.has_key? direction
        end

        def on_exit direction
            @times_visited = @times_visited + 1
        end
    end

    # Mostly a wrapper around the current room.
    # The indirection allows to have hooks to act on inputs that
    # have a broader scope than the current room
    class World
        attr_reader :current_room
        def initialize
            @rooms = {
                InfiniteEmptyRoom.id => InfiniteEmptyRoom.new
            }
            @current_room = @rooms[InfiniteEmptyRoom.id]
        end

        # TODO: Have World proxy calls to current room, with hooks to intervene
        def describe
            @current_room.describe
        end

        def look noun
            @current_room.look noun
        end

        def go direction
            if !@current_room.has_exit? direction then
                return "Going #{direction} is not an option" 
            end
            @current_room.on_exit direction
            @current_room = @rooms[@current_room.exits[direction]]
            look nil
        end

        def method_missing method, *args, &block
            "Seems like #{method.to_s.gsub '_', ' '} is not something I can do here"
        end
    end

    # Holds current world and runs the player loop
    class Game
        @@help = <<-HELP
Welcome.
You can try writing what you want to do. For example:
> look

You can also try more elaborate commands, such as:
> look around

If you want to stop, try
> exit
HELP

        def initialize
            reset
        end

        def act input
            input = input.chomp.split ' '
            verb, noun = nil
            case input.length
            when 1
                verb = input.pop
            else
                noun = input.pop
                verb = input.join '_'
            end
            case verb
            when 'exit'
                reset
                '"This must be a dream", you say. You try to wake up...'
            when 'help'
                @@help
            else 
                @world.public_send(verb, noun)
            end
        end

        def reset
            @world = World.new
        end
        
        def start
            puts @world.look nil
            
            while true
                puts act gets.chomp.split ' '
            end 
        end
    end

    class Bot
        def start
            token = ENV['TELEGRAM_GYGAX_TOKEN']
            raise 'Empty token' if token == nil
            logger = Logger.new(STDOUT)
            game = Gygax::Game.new

            logger.info('Starting...')
            Telegram::Bot::Client.run(token) do |bot|
                while true
                    bot.listen do |message|
                        if message.text
                            action = message.text.gsub('/', '')
                            bot.api.send_message(chat_id: message.chat.id, text: game.act(action))
                        end
                    end
                end
            end
        end
    end
end

Gygax::Bot.new.start