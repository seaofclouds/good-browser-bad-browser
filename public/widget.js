if (/Safari[\/\s](\d+\.\d+)/.test(navigator.userAgent)){
   document.write("<a href='http://goodbrowserbadbrowser.com/good' class='goodbrowser'><img src='http://goodbrowserbadbrowser.com/badge-good.png' alt='good browser' border='0'/></a>")
}
else if (/Firefox[\/\s](\d+\.\d+)/.test(navigator.userAgent)){ 
 var ffversion=new Number(RegExp.$1)
 if (ffversion>=1)
  document.write("<a href='http://goodbrowserbadbrowser.com/good' class='goodbrowser'><img src='http://goodbrowserbadbrowser.com/badge-good.png' alt='good browser' border='0'/></a>")
  else if (ffversion<=2)
   document.write("<a href='http://goodbrowserbadbrowser.com/bad' class='badbrowser'><img src='http://goodbrowserbadbrowser.com/badge-bad.gif' alt='bad browser' border='0'/></a>")
}
else if (/MSIE (\d+\.\d+);/.test(navigator.userAgent)){
  document.write("<a href='http://goodbrowserbadbrowser.com/bad' class='badbrowser'><img src='http://goodbrowserbadbrowser.com/badge-bad.gif' alt='bad browser' border='0'/></a>")
}
else {
  document.write("<a href='http://goodbrowserbadbrowser.com/bad' class='badbrowser'><img src='http://goodbrowserbadbrowser.com/badge-bad.gif' alt='bad browser' border='0'/></a>")
}