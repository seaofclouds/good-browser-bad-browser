var good_browser_link = "<a href='http://browserchallenge.com/"+lang+"' class='browserchallenge_goodbrowser' id='browserchallenge_badge'>"+good_browser+"</a>"
var bad_browser_link = "<a href='http://browserchallenge.com/"+lang+"' class='browserchallenge_badbrowser' id='browserchallenge_badge'>"+bad_browser+"</a>"

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