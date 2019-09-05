require 'logger'
require 'telegram_gygax/game'
require 'telegram/bot'

module TelegramGygax
    class Bot
        def start
            token = ENV['TELEGRAM_GYGAX_TOKEN']
            raise 'Empty token' if token == nil
            logger = Logger.new(STDOUT)
            game = TelegramGygax::Game.new

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