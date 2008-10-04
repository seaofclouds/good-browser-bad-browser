#use latest version of sinatra
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/vendor/sinatra/lib')

# goodbrowserbadbrowser.rb
require 'rubygems'
require 'sinatra'
require 'yaml'

not_found do
  headers["Status"] = "301 Moved Permanently"
  redirect("/")
end

configure do
  # Load our configuration file.
  CONFIG = YAML.load_file("translations.yml")
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
      @browser="<a href='http://www.apple.com/iphone/features/safari.html'>mobile safari</a>"
    elsif safari?
      @goodorbad = "good"
      @browser="<a href='http://www.apple.com/safari/download/'>safari</a>"
    elsif firefox?
      @goodorbad = "good"
      @browser="<a href='http://www.firefox.com/'>firefox</a>"
    else
      @goodorbad = "bad"
    end
  end
end

# views

get '/' do
  CONFIG["en"].each { |key, value| instance_variable_set("@#{key}", value) }
  goodorbad
  haml :index
end

get '/bad' do
  CONFIG["en"].each { |key, value| instance_variable_set("@#{key}", value) }
  @goodorbad = "bad"
  haml :index
end

get '/good' do
  CONFIG["en"].each { |key, value| instance_variable_set("@#{key}", value) }
  @goodorbad = "good"
  haml :index
end

# translations

get '/:lang' do
  CONFIG[params[:lang]].each { |key, value| instance_variable_set("@#{key}", value) }
  goodorbad
  haml :index
end

get '/t/:lang' do
  redirect "http://translate.google.com/translate_c?hl=en&sl=en&tl="+params[:lang]+"&u=http://browserchallenge.com/"
end


# stylesheets

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
    %title
      - if @goodorbad == "bad"
        = @bad_browser 
      - else
        = @good_browser
    %link{:rel => "shortcut icon", :href => "/favicon_"+"#{@goodorbad}"+".ico"}
    %link{:href=>"/main.css", :media=>"all", :rel=>"stylesheet", :type=>"text/css"}/
    - if ie?
      %link{:href=>"/ie.css", :media=>"all", :rel=>"stylesheet", :type=>"text/css"}/
    - if mobile_safari?
      %link{:href=>"/mobile_safari.css", :media=>"all", :rel=>"stylesheet", :type=>"text/css"}/
      %meta{:name => "viewport", :content => "width = device-width, initial-scale = 1.0"}/
    %script{:type=>"text/javascript"}
      :plain
        function toggle(obj) {
          var el = document.getElementById(obj);
          el.style.display = (el.style.display != 'none' ? 'none' : '' );
        }        
  %body{:id => "#{@goodorbad}"}
    .container
      #content
        = yield
      #footer 
        <script src="http://static.getclicky.com/38270.js" type="text/javascript"></script>
        <noscript><img alt="Clicky" src="http://in.getclicky.com/38270-db5.gif" /></noscript>
        %p.copyright
          something nifty from <a href="http://www.seaofclouds.com">seaofclouds</a>&trade; | 
          %a{:href=>"http://github.com/seaofclouds/good-browser-bad-browser"} contribute
        %p.translate
          Translate &raquo;
          %a{:href=>"/"} 
            %img{:src=>"/flags/us.gif",:border=>"0"}
          %a{:href=>"/es"} 
            %img{:src=>"/flags/es.gif",:border=>"0"}
          %a{:href=>"/t/fr"} 
            %img{:src=>"/flags/fr.gif",:border=>"0"}
          %a{:href=>"/t/de"} 
            %img{:src=>"/flags/de.gif",:border=>"0"}
          %a{:href=>"/t/zh-CN"} 
            %img{:src=>"/flags/cn.gif",:border=>"0"}
        
@@ index
%h2
  - if @goodorbad == "bad"
    = @bad
  - else
    = @good
.content-body 
  - if @goodorbad == "bad"
    %h3= @bad_intro
    %h4= @bad_outro
  - else
    %h3= "#{@good_intro} #{@browser}#{@good_outro}"
- unless mobile_safari?
  .content-footer
    .badge 
      - if @goodorbad == "bad"
        %a#browserchallengetext{:href=>'/bad', :class=>'badbrowser'}= @bad_browser
      - else
        %a#browserchallengetext{:href=>'/good', :class=>'goodbrowser'}= @good_browser
    %h1 
      - if @goodorbad == "bad"
        = @bad_badge_intro
      - else
        = @good_badge_intro
      %a.badge_toggle{:href=>"javascript:toggle('toggle_body')"}= @badge_toggle
    .clear
    #toggle_body{:style=>"display:none"}
      %textarea
        = "&lt;style type=&quot;text/css&quot;&gt; #browserchallengetext {font-family: georgia, serif; text-decoration: none;font-weight: normal;font-size: 160%; line-height: 1.3em; } #browserchallengetext:hover {text-decoration: underline; } a.badbrowser {color: #7f0100;} a.goodbrowser {color: #2e7f3a;} &lt;/style&gt; &lt;script language=&quot;javascript&quot; src=&quot;http://browserchallenge.com/widget-text.js&quot; type=&quot;text/javascript&quot;&gt;&lt;/script&gt;&lt;noscript&gt;&lt;a href=&quot;http://browserchallenge.com/&quot;&gt;"+@take_challenge+"&lt;/a&gt;&lt;/noscript&gt;"

@@ main
=clearfix
  &:after
    :content "."
    :display block
    :clear both
    :visibility hidden
    :line-height 0
    :height 0
!green = #2E7F3A
!red = #7f0100
*
  :margin 0
  :padding 0
body
  :text-align center
  :color #fff
  :font-size 80%
  :font-family helvetica, arial, sans-serif
  a
    :color #fff
.container
  #content
    :padding-top 4em
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
    .content-footer
      :width 39em
      :padding 1em
      :margin 0 auto
      :margin-bottom 1em
      :-webkit-border-radius 1em
      :-moz-border-radius 1em
      :background-color #eee
      :text-align left
      h1
        :font-size 120%
      .badge_toggle
        :padding-left .5em
        &:hover
          :color = !green - #222
      .badge
        :padding-top .7em
        :padding-right .5em
        :padding-left 1em
        :float right
      textarea
        :margin-top 1em
        :width 100%
        :border 1px solid #ccc
        :word-break break-word
        :font-family monaco, monospace
        :height 10em
        :line-height 1.5em
        :font-size 85%
      p
        :padding-bottom 1em
        :font-weight bold
      p.help
        :padding-bottom .3em
        :font-weight normal
      p.mt10
        :margin-top 1em
        :padding-bottom .5em
      .clear
        :clear both
      #browserchallengetext
        :font-family georgia, serif
        :text-decoration none
        :font-weight normal
        :font-size 180%
        :line-height 1.3em
        :-moz-border-radius 3px
        :-webkit-border-radius 3px
        :padding .3em
        :color #fff
        &.goodbrowser
          :background-color = !green
          :color #fff
          &:hover
            :background-color = !green - #111
        &.badbrowser
          :background-color = !red
          :color #fff
          &:hover
            :background-color = !red - #111
  #footer
    :font-size .85em
    :color #aaa
    :padding 1em
    :font-family verdana, sans-serif
    a
      :color #aaa
      &:hover #fff
    :width 60em
    :margin 0 auto
    p.copyright
      :float left
    p.translate
      :float right
      :text-align right
      +clearfix
      img
        :margin-bottom -.2em
#bad
  :background-color = !red
  .container
    #content
      .content-footer
        :color = !red - #111
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
  .content-footer
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
  :padding-left 1em
  :padding-right 1em
.container  
  #content
    :padding-top 1em
    h2
      :font-size 10em
    h3
      :font-size 190%
      :padding-top 1em
  #footer
    :font-size 85%
    :width auto
    :text-align center
    p.copyright, p.translate
      :float none
      :text-align center
      span
        :display none

@@ ie
body#good, body#bad
  .container
    #content
      .content-footer
        :width 42em
        .textbadge
          p
            :height 4em