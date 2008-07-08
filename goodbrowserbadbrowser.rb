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
%h2= @goodorbad
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
    %h1 
      - if @goodorbad == "bad"
        even though you're using a bad browser, you can still show off your flair for web standards. go ahead and put the browser challenge badge on your site.
      - else
        show the world you care about web standards and put the browser challenge badge on your site.
    .imagebadge
      %p.widget 
        - if @goodorbad == "bad"
          <a href="/bad" class="badbrowser" id="browserchallenge"><img src="/badge-bad.gif" alt="take the browser challenge" border="0" /></a>
        - else
          <a href="/good" class="goodbrowser" id="browserchallenge"><img src="/badge-good.png" alt="take the browser challenge" border="0" /></a>
      %p.help copy, then paste the code for our <strong>image badge</strong> into your site's template
      <textarea>&lt;script language=&quot;javascript&quot; src=&quot;http://browserchallenge.com/widget.js&quot; type=&quot;text/javascript&quot;&gt;&lt;/script&gt;&lt;noscript&gt;&lt;a href=&quot;http://browserchallenge.com/&quot;&gt;&lt;img alt=&quot;take the browser challenge&quot; src=&quot;http://browserchallenge.com/badge-goodbad.gif&quot; /&gt;&lt;/a&gt;&lt;/noscript&gt;</textarea>
    .textbadge
      %p.widget 
        - if @goodorbad == "bad"
          <a href='http://browserchallenge.com/good' class='baddbrowser' id='browserchallengetext'>bad browser</a>
        - else
          <a href='http://browserchallenge.com/good' class='goodbrowser' id='browserchallengetext'>good browser</a>
      %p.help
        copy, then paste the code for our glorious, css styleable <strong>text badge</strong> into your site's template.
      %textarea
        &lt;style type=&quot;text/css&quot;&gt; #browserchallengetext {font-family: georgia, serif; text-decoration: none;font-weight: normal;font-size: 160%; line-height: 1.3em; } #browserchallengetext:hover {text-decoration: underline; } a.badbrowser {color: #7f0100;} a.goodbrowser {color: #2e7f3a;} &lt;/style&gt; &lt;script language=&quot;javascript&quot; src=&quot;http://browserchallenge.com/widget-text.js&quot; type=&quot;text/javascript&quot;&gt;&lt;/script&gt;&lt;noscript&gt;&lt;a href=&quot;http://browserchallenge.com/&quot;&gt;take the browser challenge&lt;/a&gt;&lt;/noscript&gt;
    .clear

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
    h2
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
      :width 32em
      :padding 1em
      :margin 0 auto
      :margin-bottom 1em
      :-webkit-border-radius 1em
      :-moz-border-radius 1em
      :background-color #eee
      :text-align left
      h1
        :font-size 130%
        :padding-bottom 1em
      .imagebadge, .textbadge
        :width 15em
        :float left
        .widget
          :text-align center
          :height 2.5em
        textarea
          :width 97%
          :border 1px solid #ccc
          :word-break break-word
          :font-family courier, monospace
          :height 10em
          :line-height 1.5em
        p
          :padding-bottom 1em
          :font-weight bold
        p.help
          :padding-bottom .3em
          :font-weight normal
        p.mt10
          :margin-top 1em
          :padding-bottom .5em
      .imagebadge
        :width 15em
        :margin-right .95em
        :padding-right .95em
        :border-right 1px solid #ccc
      .clear
        :clear both
      #browserchallenge
        :margin 0 auto
      #browserchallengetext
        :font-family georgia, serif
        :text-decoration none
        :font-weight normal
        :font-size 160%
        :line-height 1.3em
        &:hover
          :text-decoration underline
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
        a
          :color = !red
        textarea
          :color = !red
  #footer
    :color = !red + #777
    a
      :color = !red + #777
#good
  :background-color = !green
  .badge
    :color = !green
    a
      :color = !green
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
          :height 10em
          :width 100%
          :overflow hidden