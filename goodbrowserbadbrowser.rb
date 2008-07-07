#use latest version of sinatra
$:.unshift File.dirname(__FILE__) + '/sinatra/lib'

# goodbrowserbadbrowser.rb
require 'rubygems'
require 'sinatra'

not_found do
  headers["Status"] = "301 Moved Permanently"
  redirect("/")
end

helpers do
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
  # good or bad
  def goodorbad
    if @goodorbad
      @goodorbad = @goodorbad
    elsif mobile_safari?
      @goodorbad = "good"
    elsif safari?
      @goodorbad = "good"
    elsif firefox?
      @goodorbad = "good"
    else
      @goodorbad = "bad"
    end
  end
end

get '/' do
  goodorbad
  haml :index
end

get '/bad' do
  @goodorbad = "bad"
  haml :index
end

get '/good' do
  @goodorbad = "good"
  haml :index
end

get '/main.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :main
end
get '/mobile_safari.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :mobile_safari
end
get '/widget.js' do

end
use_in_file_templates!

__END__

@@ layout
!!! XML
!!!
%html
  %head
    %title= @goodorbad + " browser"
    %link{:rel => "shortcut icon", :href => "/favicon_"+"#{@goodorbad}"+".ico"}
    %link{:href=>"/main.css", :media=>"all", :rel=>"stylesheet", :type=>"text/css"}/
    - if mobile_safari?
      %link{:href=>"/mobile_safari.css", :media=>"all", :rel=>"stylesheet", :type=>"text/css"}/
      %meta{:name => "viewport", :content => "width = device-width, initial-scale = 1.0"}/
  %body{:id => "#{@goodorbad}"}
    .container
      #content 
        = yield
      %p#footer <a href="https://github.com/seaofclouds/good-browser-bad-browser">good browser, bad browser</a> brought to you by <a href="http://www.seaofclouds.com">seaofclouds</a>, and powered with <a href="http://sinatra.rubyforge.org/">sinatra</a>
      
@@ index
%h1= @goodorbad
.content-body 
  - if @goodorbad == "bad"
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
.content-footer
  .badge
    %p show the world you care about web standards and put our challenge badge on your site
    %p <script language="javascript" src="/widget.js" type="text/javascript"></script>
    <textarea rows="3">&lt;script language=&quot;javascript&quot; src=&quot;http://goodbrowserbadbrowser.com/widget.js&quot; type=&quot;text/javascript&quot;&gt;&lt;/script&gt;</textarea>
@@ main
!green = #2E7F3A
!red = #7f0100
*
  :margin 0
  :padding 0
body
  :text-align center
  :padding-top 8em
  :color #fff
  :font-size 80%
  :font-family helvetica, arial, sans-serif
  :height 100%
.container
  :min-height 100%
  #content
    :padding-bottom 2em
    h1
      :font-weight normal
      :font-size 10em
      :font-family georgia, serif
    h3
      :font-weight normal
      :font-size 1.3em
      :padding-top .5em
    h4
      :font-weight normal
      :font-size 1.3em
      :padding-top .5em
    .content-body
      :padding-top 5em
      :padding-bottom 3em
      a
        :color #fff
    .badge
      :width 21em
      :padding 1em
      :margin 0 auto
      :-webkit-border-radius 1em
      :-moz-border-radius 1em
      :background-color #eee
      textarea
        :width 95%
        :border 1px solid #999
        :overflow hidden
        :padding .4em
      p
        :padding-bottom 1em
  #footer
    :font-size .8em
    :position absolute
    :bottom 0
    :left 0
    :width 99%
    :height 2em
    :text-align center
    :color #aaa
    a
      :color #aaa
      &:hover #fff
#bad
  :background-color = !red
  .badge
    :color = !red - #111
    textarea
      :color = !red
  #footer
    :color = !red + #777
    a
      :color = !red + #777
#good
  :background-color = !green
  .badge
    :color = !green - #111
    textarea
      :color = !green
  #footer
    :color = !green + #777
    a
      :color = !green + #777

@@ mobile_safari
body
  :padding-top 3em
  :padding-left 1em
  :padding-right 1em
#footer
  :position relative
  :padding-top 5em