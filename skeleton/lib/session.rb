require 'json'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    @cookie = req.cookies["_rails_lite_app"]
    @session = req.cookies["_rails_lite_app"] ? JSON.parse(@cookie) : {}
    # debugger
  end

  def [](key)
    @session[key]
  end

  def []=(key, val)
    # debugger
    @session[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    key = "_rails_lite_app"
    val = { path: "/", value: JSON.generate(@session)}
    res.set_cookie(key, val)
  end
end

#Rack::Session::Cookie
