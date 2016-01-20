# Maps all the updates from a list of tweets to a form
# x,y where:
# x -> Delta between the time that was inserted in the system and now
# y -> Number of RTs as measure of attention
class RtsOverTimeFunctionsBuilder
  def build_function(tweets)
    functions = []
    tweets.each do |t|
      fn_points = {}
      t.tweet_updates.each do |u|
        x = ((u.created_at - t.created_at) / SYSTEM_POLL_INTERVAL).round
        fn_points[x] = u.retweet_count
      end
      functions << fn_points
    end
    functions
  end
end
