require 'rubygems'
require 'mechanize'

require_relative 'LastFm.rb'

# simple radio object which has the address of the radio stations current song 
# the lastFm username
# and the lastFm password.
# you can then scrobble current song with it.
class RadioStation
  def initialize(args={})
    @url = args[:url]
    @username = args[:username]
    @password = args[:password]
    @oldartist = @oldsong = @newArtist  = @newSong = ""
  end
  
  # Checks to see if there is a new song currently playing on the specific radio station.
  # If there is. Scrobble it and making it the now playing song.
  # Otherwise just exit.
  def scrobbleCurrentSong
    agent = Mechanize.new
    agent.user_agent_alias = 'Mac Safari'
    page = agent.get @url

    body = page.body
    #get the title and artist
    page = agent.get @url
    recent = XmlSimple.xml_in(body)
  
    @oldArtist = @newArtist
    @oldSong = @newSong
  
    #makes sure that the last character of the song name is not a *
    newSong = recent["audio"][0]["title"][0].strip
    if(newSong[-1,1] == "*")
      newSong = newSong[0..-2]
    end
    @newSong = newSong
    @newArtist = recent["audio"][0]["artist"][0]
    
    lastFm =LastFm.new
    yourRecentTracks = lastFm.getRecentTrack(@username) #gets your most recent track from lastFm

    #Makes sure that you are not scrobbling the same song as before.
    if (@newArtist != @oldArtist && @newSong != @oldSong && yourRecentTracks != "" && @newArtist != yourRecentTracks['artist'] && @newSong != yourRecentTracks['song'])
      puts "NEW SONG SCROBBLING!"
      puts @username + ": " + @newArtist + " - " + @newSong
      
      #scrobble and now playing
      lastFm.updateNowPlaying(@username, @password, {:artist => @newArtist, :track => @newSong})
      lastFm.scrobble(@username, @password, {:artist => @newArtist, :track => @newSong})
    end

  end
  
  
end