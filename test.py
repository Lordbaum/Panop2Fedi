from mastodon import Mastodon
mastodon  =  Mastodon(access_token = "x5AAsQTsY-l67NPcyiME4Z-2S2hsypApugG4lvYIC4c", api_base_url="http://mastodon.local")
#mastodon.log_in( "admin@mastodon.local", "mastodonadmin", "ZmcIdVl8SwwjwAWGc5hDrzc1jx7oXUdruVm0he6nEqY" )
mastodon.toot("hi")