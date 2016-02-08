# Maps all the updates from a list of tweets to a form
# x,y where:
# x -> Delta between the time that was inserted in the system and now
# y -> Number of RTs as measure of attention
class RtsOverTimeFunctionsBuilder
  def build_function(tweets)
    functions = []
    tweets.each do |tweet|
      fn_points = {}
      tweet.tweet_updates.each do |update|
        x = tweet.elapsed_time(update)
        fn_points[x] = update.retweet_count
      end
      functions << fn_points
    end
    functions
  end
end
