require 'rubygems'
require_relative 'lib/radioStation.rb'



## MAKE SURE THAT YOU ADD YOUR APPLICATION TO YOUR LAST.FM ACCOUNT BEFORE YOU START.
## 
## http://www.last.fm/api/auth?api_key=API_KEY 
##
## API_KEY is what you put for API_KEY below
##
## EDIT API_KEY and SECRET for your specific last.fm api ##
API_KEY = ''
SECRET = ''

## Edit Array size to suit your needs.
radioStations = Array.new(2)
## edit url, username and password. username and password is you lastfm credentials.
## url is the NowPlaying announce for the radio station.
## below is an example for The Rock, and The Edge (2 NZ radio stations.)

radioStations[0] = RadioStation.new(
  :url => "http://www.therock.net.nz/Portals/0/Inbound/NowPlaying/NowPlaying.aspx",
  :username => "yourLastFmUsername", :password => "yourLastFmPassword")

radioStations[1] = RadioStation.new(
  :url => "http://www.theedge.co.nz/Portals/0/Inbound/NowPlaying/NowPlaying.aspx",
  :username => "yourLastFmUsername", :password => "yourLastFmPassword")


puts "Started."
# Continue scrobbling forever.
while (true)
  #scrobble all radioStations current songs.
  #checks to see if there is a new song, if so, scrobbles it, otherwise does nothing.
  radioStations.each { |item|
    item.scrobbleCurrentSong
  }
  puts "Waiting 1 minuite to check if a new song has been played."
  sleep 60
end