# McAvoy
McAvoy tracks the news reports emitted by media companies, storing and analysing the data. 

<img src="https://raw.github.com/jacobmendoza/mcavoy/master/docs/main.png" width="725">

*Disclaimer: This is just an experiment. Expect some questionable coding/design decisions*
## Features
1. Computes the severity of a news report given the impact in Twitter (retweets as key metric).
2. (*Future*) Notify.
3. (*Future*) Detect topics being reported by different sources at the same time.
4. (*Future*) Detect personal names and locations from the text of the news reports using NLP. 

## How does it work?
A Twitter list of selected media companies is constantly analysed. 
A model of the tweet that contains the news report is tracked, and its values (retweets and favorites count) 
are stored in a MongoDB database periodically. Every media source, depending on the amount of followers, generate different
impact patterns.

<img src="https://raw.github.com/jacobmendoza/mcavoy/master/docs/pattern.png" width="500">

At a specific moment in time and for an specific media source, the retweets should follow a normal distribution. 
Given this collection of retweet count values, the severity is computed using the concept
of percentile (measure indicating the value below which a given percentage of observations in a group of observations fall):

 - Retweet count below percentile 75 -> DEFAULT
 - Retweet count between percentile 75 and 85 -> YELLOW
 - Retweet count between percentile 85 and 95 -> ORANGE
 - Retweet count over percentile 95 -> RED

<img src="https://raw.github.com/jacobmendoza/mcavoy/master/docs/news-report-detail.png" width="600">
