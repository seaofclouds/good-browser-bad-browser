require 'rubygems'
require 'sinatra'
require 'haml'
require 'yaml'

not_found do
  headers["Status"] = "301 Moved Permanently"
  redirect("/")
end

configure do
  # Load translations file.
  CONFIG = YAML.load_file("translations.yml")
end

helpers do
  # Browser Checks
  def browser?(b)
    user_agents = {
      :ff   => /Firefox/,
      :iphone=> /(Mobile\/.+Safari)/,
      :safari=> /Safari/,
      :ie   => /MSIE/,
      :opera => /Opera/
    }
    user_agents[b] &&
      request.env["HTTP_USER_AGENT"] &&
      request.env["HTTP_USER_AGENT"] =~ user_agents[b]
  end
  # which browser
  def whichbrowser
    if browser?(:iphone)
      @browser="<a href='http://www.apple.com/iphone/features/safari.html'>mobile safari</a>"
    elsif browser?(:safari)
      @browser="<a href='http://www.apple.com/safari/download/'>safari</a>"
    elsif browser?(:ff)
      @browser="<a href='http://www.firefox.com/'>firefox</a>"
    end
  end
  # good or bad
  def goodorbad
    if @goodorbad
      @goodorbad = @goodorbad
    elsif browser?(:iphone) || browser?(:safari) || browser?(:ff)
      @goodorbad = "good"
    else
      @goodorbad = "bad"
    end
  end

  def translation_links
    languages = [
      %w[en english us],
      %w[de deutsch],
      %w[cn 中国],
      %w[es español],
      %w[fr français]
    ]
    languages.map do |(code,language,flag)|
      %(<a href="/#{code == "en" ? nil : code}" title="#{language}"><img src="/flags/#{flag || code}.gif" alt= "#{language}" />\n)
    end
  end
  
end

# === routes ===

# index, english
get '/' do
  CONFIG["en"].each { |key, value| instance_variable_set("@#{key}", value) }
  goodorbad
  whichbrowser
  haml :index
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

# translations
get '/:lang' do
  if CONFIG[params[:lang]]
    CONFIG[params[:lang]].each { |key, value| instance_variable_set("@#{key}", value) }
    goodorbad
    whichbrowser
    haml :index
  else
    redirect "http://translate.google.com/translate?prev=hp&hl=en&js=n&u=http%3A%2F%2Fbrowserchallenge.com&sl=en&tl="+params[:lang]
  end 
end

# test translation good or bad
get '/:lang/:goodorbad' do
  if params[:goodorbad] == "good" || params[:goodorbad] == "bad"
    CONFIG[params[:lang]].each { |key, value| instance_variable_set("@#{key}", value) }
    @goodorbad = params[:goodorbad]
    whichbrowser
    haml :index
  else
    redirect "/#{params[:lang]}"
  end
end

# === templates ===

use_in_file_templates!

__END__

@@ layout
!!! XML
!!! Strict
%html{ :xmlns => "http://www.w3.org/1999/xhtml", :lang => "en", 'xml:lang' => "en" }
  %head
    %title
      - if @goodorbad == "bad"
        = @bad_browser 
      - else
        = @good_browser
    %meta{'http-equiv'=>"content-type", :content=>"text/html; charset=UTF-8"}/
    %link{:rel => "shortcut icon", :href => "/favicon_"+"#{@goodorbad}"+".ico"}
    %link{:href=>"/main.css", :media=>"all", :rel=>"stylesheet", :type=>"text/css"}/
    - if browser?(:ie)
      %link{:href=>"/ie.css", :media=>"all", :rel=>"stylesheet", :type=>"text/css"}/
    - if browser?(:iphone)
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
        <noscript><p><img alt="Clicky" src="http://in.getclicky.com/38270-db5.gif" /></p></noscript>
        %p
          %span.copyright
            something nifty from <a href="http://www.seaofclouds.com">seaofclouds</a>&trade; | 
            %a{:href=>"http://github.com/seaofclouds/good-browser-bad-browser"} contribute
          %span.translate
            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Translate &raquo;
            %span.translations= translation_links
      :plain
        <script type="text/javascript">
        var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
        document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
        </script>
        <script type="text/javascript">
        try {
        var pageTracker = _gat._getTracker("UA-8287528-1");
        pageTracker._trackPageview();
        } catch(err) {}</script>
            
@@ index
%h2.content-header
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
- unless browser?(:iphone)
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
      %textarea{:rows=>"5", :cols=>"12"}
        = "&lt;script type=&quot;text/javascript&quot;&gt;var style='inline'; var good_browser='"+@good_browser+"'; var bad_browser='"+@bad_browser+"'; var lang='"+"#{params[:lang]}"+"'&lt;/script&gt;&lt;script src=&quot;http://browserchallenge.com/widget-text.js&quot; type=&quot;text/javascript&quot;&gt;&lt;/script&gt;&lt;noscript&gt;&lt;a href=&quot;http://browserchallenge.com/"+"#{params[:lang]}"+"&quot;&gt;"+@take_challenge+"&lt;/a&gt;&lt;/noscript&gt;"
    
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
      :font-size 13em
      :font-family georgia, serif
    h3, h4
      :font-weight normal
      :font-size 1.5em
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
          :font-size 110%
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
        :width 100%
        :border 1px solid #ccc
        :word-break break-word
        :font-family monaco, monospace
        :height 8em
        :line-height 1.5em
        :font-size 85%

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

#footer
  :font-size .85em
  :padding-bottom 1em
  :font-family verdana, sans-serif
  .translate
    img
      :border-style none !important
      :margin-bottom -.2em
            
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