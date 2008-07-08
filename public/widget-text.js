if (/Safari[\/\s](\d+\.\d+)/.test(navigator.userAgent)){
   document.write("<a href='http://browserchallenge.com/good' class='goodbrowser' id='browserchallengetext'>good browser</a>")
}
else if (/Firefox[\/\s](\d+\.\d+)/.test(navigator.userAgent)){ 
 var ffversion=new Number(RegExp.$1)
 if (ffversion>=1)
  document.write("<a href='http://browserchallenge.com/good' class='goodbrowser' id='browserchallengetext'>good browser</a>")
  else if (ffversion<=2)
   document.write("<a href='http://browserchallenge.com/bad' class='badbrowser' id='browserchallengetext'>bad browser</a>")
}
else if (/MSIE (\d+\.\d+);/.test(navigator.userAgent)){
  document.write("<a href='http://browserchallenge.com/bad' class='badbrowser' id='browserchallengetext'>bad browser</a>")
}
else {
  document.write("<a href='http://browserchallenge.com/bad' class='badbrowser' id='browserchallengetext'>bad browser</a>")
}