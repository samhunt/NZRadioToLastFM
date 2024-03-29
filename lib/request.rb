require 'net/https'

# simple post and get web request library.
# returns body of request.
# http://scrobbler.rubyforge.org/docs/files/lib/scrobbler/rest_rb.html
class Request
  def initialize(base_url, args = {})
    @base_url = base_url
    @username = args[:username]
    @password = args[:password]
  end

  def get(resource, args = nil)
    request(resource, "get", args)
  end

  def post(resource, args = nil)
    request(resource, "post", args)
  end

  def request(resource, method = "get", args = nil)
    url = URI.join(@base_url, resource)

    if args
      # TODO: What about keys without value?
      url.query = args.map { |k,v| "%s=%s" % [URI.encode(k.to_s).sub(/&/, "%26"), URI.encode(v.to_s).sub(/&/, "%26")] }.join("&")
    end
    case method
    when "get"
      req = Net::HTTP::Get.new(url.request_uri)
    when "post"
      req = Net::HTTP::Post.new(url.request_uri)
    end
    if @username and @password
    req.basic_auth(@username, @password)
    end

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.port == 443)
    # set content length
    if(req.body == nil)
      req['Content-length'] = 0
    else
      req['Content-length'] = req.body.length
    end
        
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
    res = http.start() { |conn| conn.request(req) }
    res.body
  end
end
