require 'twitter_ebooks'

class RijksBot < Ebooks::Bot

  def configure
    # Consumer details come from registering an app at https://dev.twitter.com/
    # Once you have consumer details, use "ebooks auth" for new access tokens
    self.consumer_key = ""
    self.consumer_secret = ""
  end

  def on_startup
    scheduler.cron '0 0 * * *' do
      # Each day at midnight, post a single tweet
      tweet('Hallo')
    end
  end

  def on_message(dm)
  end

  def on_mention(tweet)
  end

  def on_timeline(tweet)
  end


  def favorite(tweet)
  end

  def on_follow(user)
  end

  private
end

RijksBot.new("rijks_bot") do |bot|
  bot.access_token = ""
  bot.access_token_secret = ""
end
