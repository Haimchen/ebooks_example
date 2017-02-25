require 'twitter_ebooks'
require 'dotenv'
require 'rijksmus-api'
require 'httparty'
Dotenv.load

class RijksBot < Ebooks::Bot

  def configure
    # Consumer details come from registering an app at https://dev.twitter.com/
    # Once you have consumer details, use "ebooks auth" for new access tokens
    self.consumer_key = ENV["consumer_key"]
    self.consumer_secret = ENV["consumer_secret"]
  end

  def on_startup
    tweet('I am online: Send me search requests!')
    # scheduler.cron '0 0 * * *' do
    #   # Each day at midnight, post a single tweet
    #   tweet('Hallo')
    # end
  end

  def on_message(dm)
  end

  def on_mention(tweet)
    search_term = meta(tweet).mentionless
    puts "Searching images for #{search_term}"
    api_key = ENV["rijksmuseum_api_key"]

    images = Rijksmus::API::Client.new(search_term, api_key).random_image_search
    random_number = rand(0..9)
    random_object_image_url = images["artObjects"][random_number]["webImage"]["url"]
    random_object_title = images["artObjects"][random_number]["longTitle"]
    reply_text = 'Found: #{random_object_title} #{random_object_image_url}'
    
    reply(tweet, reply_text)
  end

  def on_timeline(tweet)
  end


  def favorite(tweet)
  end

  def on_follow(user)
  end

  private

  # Reply to a tweet or a DM.
  # @param ev [Twitter::Tweet, Twitter::DirectMessage]
  # @param text [String] contents of reply excluding reply_prefix
  # @param opts [Hash] additional params to pass to twitter gem
  # def reply(ev, text, image_url, opts={})
  #   opts = opts.clone

  #   if ev.is_a? Twitter::DirectMessage
  #     log "Sending DM to @#{ev.sender.screen_name}: #{text}"
  #     twitter.create_direct_message(ev.sender.screen_name, text, opts)
  #   elsif ev.is_a? Twitter::Tweet
  #     meta = meta(ev)

  #     if conversation(ev).is_bot?(ev.user.screen_name)
  #       log "Not replying to suspected bot @#{ev.user.screen_name}"
  #       return false
  #     end

  #     File.open("/tmp/image.jpg", "wb") do |f| 
  #       f.binmode
  #       f.write HTTParty.get(image_url).parsed_response
  #       f.close
  #     end
  #     media = [File.open("/tmp/image.jpg")]
  #     text = meta.reply_prefix + text unless text.match(/@#{Regexp.escape ev.user.screen_name}/i)
  #     log "Replying to @#{ev.user.screen_name} with: #{text}"
  #     tweet = twitter.update_with_media(text, media, opts.merge(in_reply_to_status_id: ev.id))
  #     conversation(tweet).add(tweet)
  #     tweet
  #   else
  #     raise Exception("Don't know how to reply to a #{ev.class}")
  #   end
  # end

  def random_image_reply search_term
  end
end

RijksBot.new("rijks_bot") do |bot|
  bot.access_token = ENV["access_token"]
  bot.access_token_secret = ENV["access_token_secret"]
end
