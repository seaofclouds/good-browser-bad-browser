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
get '/ie.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :ie
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
    - if ie?
      %link{:href=>"/ie.css", :media=>"all", :rel=>"stylesheet", :type=>"text/css"}/
    - if mobile_safari?
      %link{:href=>"/mobile_safari.css", :media=>"all", :rel=>"stylesheet", :type=>"text/css"}/
      %meta{:name => "viewport", :content => "width = device-width, initial-scale = 1.0"}/
  %body{:id => "#{@goodorbad}"}
    .container
      #content 
        = yield
      %p#footer 
        <script src="http://static.getclicky.com/38270.js" type="text/javascript"></script>
        <noscript><img alt="Clicky" src="http://in.getclicky.com/38270-db5.gif" /></noscript>
        something nifty from <a href="http://www.seaofclouds.com">seaofclouds</a>&trade; | <a href="http://github.com/seaofclouds/good-browser-bad-browser">contribute</a>
      
@@ index
%h1= @goodorbad
.content-body 
  - if @goodorbad == "bad"
    %h3 treat yourself to something good.
    %h4 upgrade to <a href="http://www.apple.com/safari/download/">safari</a> or <a href="http://firefox.com/">firefox</a> today!
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
- unless mobile_safari?
  .badge
    %p 
      - if @goodorbad == "bad"
        <a href="/bad" class="badbrowser" id="goodbrowserbadbrowser"><img src="/badge-bad.gif" alt="take the browser challenge" border="0" /></a>
        even though you're using a bad browser, you can still show off your flair for web standards. go ahead and put our challenge badge on your site.
      - else
        <a href="/good" class="goodbrowser" id="goodbrowserbadbrowser"><img src="/badge-good.png" alt="take the browser challenge" border="0" /></a>
        show the world you care about web standards and put our challenge badge on your site.
    %p.help copy, then paste the code into your site's template
    <textarea rows="7">&lt;script language=&quot;javascript&quot; src=&quot;http://goodbrowserbadbrowser.com/widget.js&quot; type=&quot;text/javascript&quot;&gt;&lt;/script&gt;&lt;noscript&gt;&lt;a href=&quot;http://goodbrowserbadbrowser.com/&quot;&gt;&lt;img alt=&quot;take the browser challenge&quot; src=&quot;http://goodbrowserbadbrowser.com/badge-goodbad.gif&quot; /&gt;&lt;/noscript&gt;</textarea>

@@ main
!green = #2E7F3A
!red = #7f0100
*
  :margin 0
  :padding 0
body
  :text-align center
  :padding-top 5em
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
      :font-size 15em
      :font-family georgia, serif
    h3, h4
      :font-weight normal
      :font-size 1.74em
      :padding-top .5em
    .content-body
      :padding-top 3em
      :padding-bottom 8em
      a
        :color #fff
    .badge
      :width 31em
      :padding 1em
      :margin 0 auto
      :-webkit-border-radius 1em
      :-moz-border-radius 1em
      :background-color #eee
      :text-align left
      #goodbrowserbadbrowser
        :float right
        :margin-left 1em
      textarea
        :width 97%
        :border 1px solid #999
        :padding .4em
        :word-break break-word
        :font-family monaco, monospace
        :font-size 85%
      p
        :padding-bottom 1em
        :font-weight bold
      p.help
        :font-size 85%
        :font-family verdana, sans-serif
        :padding-bottom .3em
        :color #777
        :font-weight normal
  #footer
    :font-size .85em
    :text-align center
    :color #aaa
    :padding 1em
    :font-family verdana, sans-serif
    a
      :color #aaa
      &:hover #fff
#bad
  :background-color = !red
  .container
    #content
      .badge
        :color = !red - #111
        :width 33em
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
.container  
  #content
    h1
      :font-size 10em
    h3
      :font-size 190%
  #footer
    :font-size 100%

@@ ie
body
  .container
    #content
      .badge
        :width 35em
        textarea
          :height 11em
          :overflow hidden