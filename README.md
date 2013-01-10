NZRadioToLastFM
===============

Scrobbles songs played by some NZ radio stations to last.fm

Usage
-----
    radioStation =  RadioStation.new( :url => URL, :username => LASTFMUSERNAME, :password => LASTFMPASSWORD)
    radioStation.scrobbleCurrentSong


Simple Last.Fm api calls
------------------------

    lastFm = LastFM(api_key, secret) #initializatoin
    lastFm.getRecentTrack(username) #returns the track name and artist most recently played by "sername"
    lastFm.scrobble(username, password, args={}) #scrobbles the current song (as long as it includes a title and artist
    lastFm.updateNowPlaying(username, password, args={}) # same as for scrobble, but updates the now playing song.

