var good_browser_link = "<a href='http://browserchallenge.com/good/"+lang+"' class='goodbrowser' id='browserchallengetext'>"+good_browser+"</a>"
var bad_browser_link = "<a href='http://browserchallenge.com/bad/"+lang+"' class='badbrowser' id='browserchallengetext'>"+bad_browser+"</a>"

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