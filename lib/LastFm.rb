require 'xmlsimple'
require 'digest/md5'

require_relative 'request.rb'

# adds select_keys to the Hash object.
# allows tyou select certain keys from the Hash table if they exist.
class Hash
  def select_keys(*args)
    select {|k,v| args.include?(k) }
  end
end

# simple library to connect to the last.fm api
class LastFm
  
  # Initialize with set arguments.
  def initialize(apiKey, secret)
    @apiKey = apiKey
    @secret = secret
  end
  
  # Initialize with no arguments
  def initialize
    @apiKey = API_KEY
    @secret = SECRET
  end

  # gets users most recent track
  # returns an empty string if status failed.
  def getRecentTrack(username)
    connection = Request.new("http://ws.audioscrobbler.com/2.0/")
    query =
    {
      :method => "user.getrecenttracks",
      :user => username,
      :limit => "1",
      :api_key => @apiKey
    }
    xml = connection.get("", query)
    doc = XmlSimple.xml_in(xml)

    if(doc["status"] == "ok")
      track = Hash.new
      if(doc["recenttracks"][0]["page"] == "0")
        puts username + " has not listened to any tracks"
        track['artist'] = ""
        track['song'] = ""
      else
        track['artist'] = doc["recenttracks"][0]["track"][0]["artist"][0]["content"]
        track['song'] = doc["recenttracks"][0]["track"][0]["name"][0]
      end
      return track
    end
    puts "\tGet recent track failed"
    puts "\t"+doc["error"][0]["code"][0]+": " +doc["error"][0]["content"][0]
    return ""
  end
  
  # Scrobbles the song in the arguments
  # required
  # artist, track, timestamp
  # optional
  # album, context, streamId, chosenByUser, trackNumber, mbid, duration, albumArtist
  # also make sure that there is no extra arguments.
  def scrobble(username, password, args = {})
    if(args[:artist].to_s.strip.length == 0 || args[:track].to_s.strip.length == 0)
      puts "\tTo scrobble a song you must include an artist, and a track name.\t\n Scrobbling failed."
      return
    end
    
    if(args[:timestamp].to_s.strip.length == 0)
      args[:timestamp] = Time.new.to_i.to_s
    end
    
    session_key = getMobileSession(username, password)
    if(session_key == "failed")
      puts "\tScrobbling failed."
      return
    end
    realArgs = args.select_keys(:artist, :track, :timestamp, :album, :context, :streamId, :chosenByUser, :trackNumber, :mbid, :duration, :albumArtist)
    realArgs[:method] = "track.scrobble"
    realArgs[:sk] = session_key
    realArgs[:username] = username
    realArgs[:password] = password
    realArgs[:api_key] = @apiKey
    realArgs.each{|k,v| realArgs[k] = URI.unescape(v.to_s.strip)}
    sig = signatureMobile(realArgs)
    realArgs[:api_sig] = sig
    
    connection = Request.new("https://ws.audioscrobbler.com/2.0/")
    xml = connection.post("", realArgs)
    doc = XmlSimple.xml_in(xml)

    if(doc["status"] != "ok")
      puts "\tScrobbling failed."
    else
      puts "\tScrobbling was successful."
    end
  end
  
  # Updates the song now playing for user.
  # required
  # artist, track, api_key, api_sig, sk
  # optional
  # album, trackNumber, context, mbid, duration, albumArtist
  def updateNowPlaying(username, password, args = {})
    if(args[:artist].to_s.strip.length == 0 || args[:track].to_s.strip.length == 0)
      puts "To update the now playing song you must include an artist, and a track name.\n Scrobbling failed."
      return
    end
    
    session_key = getMobileSession(username, password)
    if(session_key == "failed")
      puts "\tNow playing update failed."
      return
    end
    realArgs = args.select_keys(:artist, :track, :album, :context, :trackNumber, :mbid, :duration, :albumArtist)
    realArgs[:method] = "track.updateNowPlaying"
    realArgs[:sk] = session_key
    realArgs[:username] = username
    realArgs[:password] = password
    realArgs[:api_key] = @apiKey
    
    realArgs.each{|k,v| realArgs[k] = URI.unescape(v.to_s.strip.encode('utf-8'))}
    
    sig = signatureMobile(realArgs)
    realArgs[:api_sig] = sig
    
    connection = Request.new("https://ws.audioscrobbler.com/2.0/")
    xml = connection.post("", realArgs)
    doc = XmlSimple.xml_in(xml)
    
    if(doc["status"] != "ok")
      puts "\tNow playing update failed."
    else
      puts "\tNow playing update was successful."
    end
  end
  
  private #everything after here is private.
  
  # gets mobile session key.
  def getMobileSession(username, password)
    #authToken = Digest::MD5.hexdigest(@username + Digest::MD5.hexdigest(@password))
    api_sig = signatureMobile({:method => "auth.getMobileSession", :password => password, :username => username, :api_key => @apiKey})

    connection = Request.new("https://ws.audioscrobbler.com/2.0/")
    query =
    {
      :method => "auth.getMobileSession",
      :api_key => @apiKey,
      :api_sig => api_sig,
      :username => username,
      :password => password
    }
    xml = connection.post("", query)
    doc = XmlSimple.xml_in(xml)
    if(doc["status"] == "failed")
      puts "\tgetMobileSession failed, code: " + doc["error"][0]["code"] + " content: " + doc["error"][0]["content"]
      return "failed"
    else
      return doc["session"][0]["key"][0]
    end
  end
  
  # gets the signature for the specific api call.
  def signatureMobile(args = {})
    sig = args.sort.map { |k,v| [k.to_s, v.to_s] }.join
    sig = sig + @secret
    return Digest::MD5.hexdigest(sig)
  end
  
end