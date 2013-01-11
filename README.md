NZRadioToLastFM
===============

Scrobbles songs played by mediaworks[1] radio stations in New Zealand to last.fm

Usage
-----
As is shown in test.rb

    radioStation =  RadioStation.new( :url => "url", :username => "lastFmUsername", :password => "lastFmPassword")
    radioStation.scrobbleCurrentSong


Simple Last.Fm api calls
------------------------

    lastFm = LastFM(api_key, secret) #initializatoin
    lastFm.getRecentTrack(username) #returns the track name and artist most recently played by "username"
    lastFm.scrobble(username, password, args={}) #scrobbles the current song (as long as it includes a title and artist
    lastFm.updateNowPlaying(username, password, args={}) # same as for scrobble, but updates the now playing song.

