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
  # which browser
  def whichbrowser
    if mobile_safari?
      @browser="<a href='http://www.apple.com/iphone/features/safari.html'>mobile safari</a>"
    elsif safari?
      @browser="<a href='http://www.apple.com/safari/download/'>safari</a>"
    elsif firefox?
      @browser="<a href='http://www.firefox.com/'>firefox</a>"
    end
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

# views

get '/' do
  CONFIG["en"].each { |key, value| instance_variable_set("@#{key}", value) }
  goodorbad
  whichbrowser
  haml :index
end

# test views

get '/bad' do
  CONFIG["en"].each { |key, value| instance_variable_set("@#{key}", value) }
  @goodorbad = "bad"
  haml :index
end
get '/bad/:lang' do
  CONFIG[params[:lang]].each { |key, value| instance_variable_set("@#{key}", value) }
  @goodorbad = "bad"
  whichbrowser
  haml :index
end
get '/good' do
  CONFIG["en"].each { |key, value| instance_variable_set("@#{key}", value) }
  @goodorbad = "good"
  whichbrowser
  haml :index
end
get '/good/:lang' do
  CONFIG[params[:lang]].each { |key, value| instance_variable_set("@#{key}", value) }
  @goodorbad = "good"
  whichbrowser
  haml :index
end

# translations

get '/:lang' do
  CONFIG[params[:lang]].each { |key, value| instance_variable_set("@#{key}", value) }
  goodorbad
  whichbrowser
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
    %meta{'http-equiv'=>"content-type", :content=>"text/html; charset=UTF-8"}/
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
        %p
          %span.copyright
            something nifty from <a href="http://www.seaofclouds.com">seaofclouds</a>&trade; | 
            %a{:href=>"http://github.com/seaofclouds/good-browser-bad-browser"} contribute
          %span.translate
            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Translate &raquo;
            %a{:href=>"/"} <img src="/flags/us.gif" border="0" />
            %a{:href=>"/de"} <img src="/flags/de.gif" border="0" />
            %a{:href=>"/cn"} <img src="/flags/cn.gif" border="0" />
            %a{:href=>"/es"} <img src="/flags/es.gif" border="0" />
            %a{:href=>"/fr"} <img src="/flags/fr.gif" border="0" />
        
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
    %table{:cellspacing=>"0", :cellpadding=>"0", :border=>"0"}
      %tr
        %td.badge_intro{:valign=>"middle"}
          %h1 
            - if @goodorbad == "bad"
              = @bad_badge_intro
            - else
              = @good_badge_intro
            &nbsp;
            %a.badge_toggle{:href=>"javascript:toggle('toggle_body')"}= @badge_toggle
        %td.badge{:valign=>"middle"}
          - if @goodorbad == "bad"
            %a#browserchallenge_badge{:href=>'/'+"#{params[:lang]}", :class=>'browserchallenge_badbrowser'}= @bad_browser
          - else
            %a#browserchallenge_badge{:href=>'/'+"#{params[:lang]}", :class=>'browserchallenge_goodbrowser'}= @good_browser

    #toggle_body{:style=>"display:none"}
      %textarea
        = "&lt;style type=&quot;text/css&quot;&gt; #browserchallenge_badge { font-family: georgia, serif !important; text-decoration: none !important; font-weight: normal !important; font-size: 180% !important; line-height: 1.3em !important; -moz-border-radius: 3px !important; -webkit-border-radius: 3px !important; padding: .3em !important; color: #fff !important; white-space: nowrap !important; } .browserchallenge_goodbrowser { background-color: #2e7f3a !important; color: #fff !important; background-image: url(http://browserchallenge.com/badge-bg-good.png) !important; background-repeat: repeat-x !important; background-position: center bottom !important; } .browserchallenge_goodbrowser:hover { background-color: #1d6e29 !important; } .browserchallenge_badbrowser { background-color: #7f0100 !important; color: #fff !important; } .browserchallenge_badbrowser:hover { background-color: #6e0000 !important; } &lt;/style&gt; &lt;script type=&quot;text/javascript&quot;&gt;var good_browser='"+@good_browser+"'; var bad_browser='"+@bad_browser+"'; var lang='"+"#{params[:lang]}"+"'&lt;/script&gt;&lt;script src=&quot;http://browserchallenge.com/widget-text.js&quot; type=&quot;text/javascript&quot;&gt;&lt;/script&gt;&lt;noscript&gt;&lt;a href=&quot;http://browserchallenge.com/"+"#{params[:lang]}"+"&quot;&gt;"+@take_challenge+"&lt;/a&gt;&lt;/noscript&gt;"

@@ main
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
      :width 40em
      :margin 0 auto
      :-webkit-border-radius 1em
      :-moz-border-radius 1em
      :background-color #eee
      :text-align left
      td
        :padding-top 1em
        :padding-bottom 1em
      .badge_intro
        :padding-left 1em
        :padding-right 2em
        :background-image url(arrow-fade.gif)
        :background-repeat no-repeat
        :background-position right center
        h1
          :font-size 120%
          :text-transform lowercase
        .badge_toggle
          :white-space nowrap
      .badge
        :white-space nowrap
        :padding-right 1em
        :padding-left 1em
      #toggle_body
        :padding 0 1em 1em 1em
      textarea
        :margin-top 1em
        :width 100%
        :border 1px solid #ccc
        :word-break break-word
        :font-family monaco, monospace
        :height 10em
        :line-height 1.5em
        :font-size 85%
  #footer
    :font-size .85em
    :color #aaa
    :padding 1em
    :font-family verdana, sans-serif
    a
      :color #aaa
      &:hover #fff
    %span.translate
      img
        :margin-bottom -.2em

// browser challenge badge
        
#browserchallenge_badge
  :font-family georgia, serif !important
  :text-decoration none !important
  :font-weight normal !important
  :font-size 180% !important
  :line-height 1.3em !important
  :-moz-border-radius 3px !important
  :-webkit-border-radius 3px !important
  :padding .3em !important
  :color #fff !important
  :white-space nowrap !important
.browserchallenge_goodbrowser
  :background-color = !green  !important
  :color #fff !important
  :background-image url(http://browserchallenge.com/badge-bg-good.png) !important
  :background-repeat repeat-x !important
  :background-position center bottom !important
  &:hover
    :background-color = !green - #111  !important
.browserchallenge_badbrowser
  :background-color = !red !important
  :color #fff !important
  &:hover
    :background-color = !red - #111 !important

#bad
  :background-color = !red
  .container
    #content
      .content-footer
        td
          :color = !red - #111
          a
            :color = !red
            &:hover
              :color = !red - #222
        textarea
          :color = !red
  #footer
    :color = !red + #777
    a
      :color = !red + #777
#good
  :background-color = !green
  .content-footer
    td
      :color = !green
      a
        :color = !green
        &:hover
          :color = !green - #222
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

@@ ie
body#good, body#bad
  .container
    #content
      .content-footer
        :width 48em
        td
          :font-size .95em