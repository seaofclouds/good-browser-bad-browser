if (/Safari[\/\s](\d+\.\d+)/.test(navigator.userAgent)){
   document.write("<a href='http://browserchallenge.com/good' class='goodbrowser' id='browserchallenge'><img src='http://browserchallenge.com/badge-good.png' alt='good browser' border='0'/></a>")
}
else if (/Firefox[\/\s](\d+\.\d+)/.test(navigator.userAgent)){ 
 var ffversion=new Number(RegExp.$1)
 if (ffversion>=1)
  document.write("<a href='http://browserchallenge.com/good' class='goodbrowser' id='browserchallenge'><img src='http://browserchallenge.com/badge-good.png' alt='good browser' border='0'/></a>")
  else if (ffversion<=2)
   document.write("<a href='http://browserchallenge.com/bad' class='badbrowser' id='browserchallenge'><img src='http://browserchallenge.com/badge-bad.gif' alt='bad browser' border='0'/></a>")
}
else if (/MSIE (\d+\.\d+);/.test(navigator.userAgent)){
  document.write("<a href='http://browserchallenge.com/bad' class='badbrowser' id='browserchallenge'><img src='http://browserchallenge.com/badge-bad.gif' alt='bad browser' border='0'/></a>")
}
else {
  document.write("<a href='http://browserchallenge.com/bad' class='badbrowser' id='browserchallenge'><img src='http://browserchallenge.com/badge-bad.gif' alt='bad browser' border='0'/></a>")
}