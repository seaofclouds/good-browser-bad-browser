var good_browser_link = "<a href='http://browserchallenge.com/"+lang+"' class='browserchallenge_goodbrowser' id='browserchallenge_badge'>"+good_browser+"</a>"
var bad_browser_link = "<a href='http://browserchallenge.com/"+lang+"' class='browserchallenge_badbrowser' id='browserchallenge_badge'>"+bad_browser+"</a>"

if (style='inline') {
  document.write(
    '<style type="text/css"> #browserchallenge_badge { font-family: georgia, serif !important; text-decoration: none !important; font-weight: normal !important; font-size: 180% !important; line-height: 1.3em !important; -moz-border-radius: 3px !important; -webkit-border-radius: 3px !important; padding: .3em !important; color: #fff !important; white-space: nowrap !important; } .browserchallenge_goodbrowser { background-color: #2e7f3a !important; color: #fff !important; background-image: url(http://browserchallenge.com/badge-bg-good.png) !important; background-repeat: repeat-x !important; background-position: center bottom !important; } .browserchallenge_goodbrowser:hover { background-color: #1d6e29 !important; } .browserchallenge_badbrowser { background-color: #7f0100 !important; color: #fff !important; } .browserchallenge_badbrowser:hover { background-color: #6e0000 !important; } </style>'
    )
}
if (/Safari[\/\s](\d+\.\d+)/.test(navigator.userAgent)){
  document.write(good_browser_link)
}
else if (/Firefox[\/\s](\d+\.\d+)/.test(navigator.userAgent)){ 
  var ffversion=new Number(RegExp.$1)
  if (ffversion>=1) 
    document.write(good_browser_link)
  else if (ffversion<=2) 
    document.write(bad_browser_link) 
  }
else if (/MSIE (\d+\.\d+);/.test(navigator.userAgent)){
  document.write(bad_browser_link)
}
else {
  document.write(bad_browser_link)
}