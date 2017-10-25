library(twitteR)
library(ROAuth)
library(httr)
library(RMongo)
library(rjson)

#set API Keys
api_key <- "LdP43JuM1h7CWVHJ59n9cKkfS"
api_secret <- "jqE6yUxgLCKKNHPm73Uc7L5nhExfz0mVcMOdx6NzQ29hLD3YXo"
access_token <- "2314102710-0Q2b2xar6cICo1qKIf91avCfnIRfolwpQeNNyoU"
access_token_secret <- "0O4gzwhnjUGG4kRsSaLw1Bxo7M93OuFzCBfzeRsLwA5xl"
setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)

tweets_blockbuster <- searchTwitter('@loneblockbuster', n=20)
x <- toJSON(tweets_blockbuster)
as.list(tweets_blockbuster)

auth <- setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)

filterStream(file="tweets_rstats.json", track="", timeout = 3600, oauth = my_oauth )
