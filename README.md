NZRadioToLastFM
===============

Scrobbles songs played by [MediaWorks radio stations][1] in New Zealand to last.fm

An example of this code in action can be found a [TheEdgeNZ last.fm][2]

Usage
-----
As is shown in test.rb
```ruby
radioStation =  RadioStation.new( :url => "url", :username => "lastFmUsername", :password => "lastFmPassword")
radioStation.scrobbleCurrentSong
```

Simple Last.Fm api calls
------------------------

```ruby
lastFm = LastFM(api_key, secret) #initializatoin
lastFm.getRecentTrack(username) #returns the track name and artist most recently played by "username"
lastFm.scrobble(username, password, args={}) #scrobbles the current song (as long as it includes a title and artist
lastFm.updateNowPlaying(username, password, args={}) # same as for scrobble, but updates the now playing song.
```

[1]: http://www.mediaworks.co.nz/Radio/OurRadioStations.aspx "MediaWorks radio stations"
[2]: http://www.last.fm/user/TheEdgeNZ
