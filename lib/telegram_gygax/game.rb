require 'telegram_gygax/world'

module TelegramGygax
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
    end
end