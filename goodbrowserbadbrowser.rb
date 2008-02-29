# goodbrowserbadbrowser.rb
require 'rubygems'
require 'sinatra'

Sinatra::Options.set_environment :production

# Browser Checks
def mobile_safari?
  request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/]
end
def ie?
  request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"].include?("MSIE")
end
def safari?
  request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"].include?("Safari")
end
def firefox?
  request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"].include?("Firefox")
end

get '/' do
  if ie?
    goodorbad = "bad"
    browser = "Internet Explorer"
  else
    goodorbad = "good"
  end
  
  haml <<-haml
!!! XML
!!!
%html
  %head
    %title #{goodorbad} browser
    - if mobile_safari?
      %meta{:name => "viewport", :content => "width = device-width, initial-scale = 1.0"}/
    %style{:type => "text/css"}
      :plain
        * {
          margin:0;
          padding:0;
        }
        body {
          text-align:center;
          padding-top:8em;
          color:#fff;
          font-size:80%;
          background-color:#777;
          font-family:helvetica, arial, sans-serif;
          height:100%;
        }
        a {
          text-decoration:none;
        }
        a:hover {
          text-decoration:underline;
        }
        .container {
          min-height:100%;
        }
        #content {
          padding-bottom:2em;
        }
        h1, h3, h4 {
          font-weight:normal;
        }
        h1 {
          font-size:10em;
          font-family:georgia, serif;
        }
        h3, h4 {
          font-size: 1.3em;
          padding-top: .5em;
        }
        .content-body {
          padding-top:7em;
        }
        .content-body a {
          color: #fff;
        }
        #footer {
          font-size:.8em;
          position:absolute;
          bottom:0;
          left:0;
          width:99%;
          height:2em;
          text-align:center;
        }
        #footer,
        #footer a {
          color:#aaa;
        }
        #bad {
          background-color: #7f0100;
        }
        #footer a:hover {
          color:#fff;
        }
        #good {
          background-color: #2E7F3A;
        }
        #good #footer,
        #good #footer a {
          color:#BDFFB0;
        }
      - if mobile_safari?
        :plain
          body {
            padding-top:3em;
            padding-left:1em;
            padding-right:1em;
          }
          #footer {
          position:relative;
          padding-top:5em;
          }
  %body{:id => "#{goodorbad}"}
    .container
      #content 
        %h1 #{goodorbad}
        .content-body 
          - if ie?
            %h3 treat yourself to something good.
            %h4 download <a href="http://www.apple.com/safari/download/">safari</a> or <a href="http://firefox.com/">firefox</a> today!
          - else
            %h3 
              you're using 
              - if safari?
                - if mobile_safari?
                  mobile safari,
                - else
                  <a href="http://www.apple.com/safari/">safari</a>,
              - if firefox?
                <a href="http://www.firefox.com">firefox</a>,
              a good web browser.
      %p#footer <a href="http://goodbrowserbadbrowser.com">good browser, bad browser</a> brought to you by <a href="http://www.seaofclouds.com">seaofclouds</a>, and powered with <a href="http://sinatra.rubyforge.org/">sinatra</a>.

    haml
end

get 404 do
  headers["Status"] = "301 Moved Permanently"
  redirect("/")
end