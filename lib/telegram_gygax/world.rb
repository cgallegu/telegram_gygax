require 'telegram_gygax/rooms/infinite_empty_room'

module TelegramGygax
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
end