require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require 'byebug'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    # debugger
    @req = req
    @res = res
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise "Already Built Response" if already_built_response?
    @res.status = 302
    @res.location = url
    @already_built_response = true
    @session.store_session(@res)
  end
  
  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise "Already Built Response" if already_built_response?
    @res.write(content)
    @res.content_type = content_type
    @already_built_response = true
    @session.store_session(@res)
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name) #:index
    template_file = File.read(File.join("views", "#{self.class.to_s.underscore}", "#{template_name}.html.erb"))
    content = ERB.new(template_file).result(binding)
    render_content(content, "text/html")
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    # debugger
  end
end

#req <Rack::Request:0x00007f84ff9bd5f8 @params=nil, @env={"rack.input"=>{}}>
#res <Rack::MockResponse:0x00007f8500910e38 @original_headers={}, @errors="", @cookies={}, @status=200, @headers={}, @writer=#<Method: Rack::MockResponse(Rack::Response::Helpers)#append>, @block=nil, @body=[], @buffered=true, @length=0>
#content = 'somebody'
#content_type "text/html"