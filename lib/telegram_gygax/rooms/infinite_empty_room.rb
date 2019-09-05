module TelegramGygax
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
end
