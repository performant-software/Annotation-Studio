!function(){"use strict";function e(e,t){var n=e.getBody();n&&(n.style.overflowY=t?"":"hidden",t||(n.scrollTop=0))}function t(e,t,n,i){var o=parseInt(e.getStyle(t,n,i),10);return isNaN(o)?0:o}var n=function(e){function t(){return i}var i=e;return{get:t,set:function(e){i=e},clone:function(){return n(t())}}},i=tinymce.util.Tools.resolve("tinymce.PluginManager"),o=tinymce.util.Tools.resolve("tinymce.Env"),r=tinymce.util.Tools.resolve("tinymce.util.Delay"),u=function(e){return e.fire("ResizeEditor")},s=function(e){return e.getParam("min_height",e.getElement().offsetHeight,"number")},a=function(e){return e.getParam("max_height",0,"number")},f=function(e){return e.getParam("autoresize_overflow_padding",1,"number")},c=function(e){return e.getParam("autoresize_bottom_margin",50,"number")},g=function(e){return e.getParam("autoresize_on_init",!0,"boolean")},l=function(e,t,n,i,o){r.setEditorTimeout(e,(function(){m(e,t),n--?l(e,t,n,i,o):o&&o()}),i)},m=function(n,i){var r,f,g,l=n.dom,d=n.getDoc();if(d)if(function(e){return e.plugins.fullscreen&&e.plugins.fullscreen.isFullscreen()}(n))e(n,!0);else{var h=d.documentElement,v=c(n);f=s(n);var p=t(l,h,"margin-top",!0),y=t(l,h,"margin-bottom",!0);(g=h.offsetHeight+p+y+v)<0&&(g=0);var z=n.getContainer().offsetHeight-n.getContentAreaContainer().offsetHeight;g+z>s(n)&&(f=g+z);var b=a(n);if(b&&b<f?(f=b,e(n,!0)):e(n,!1),f!==i.get()){if(r=f-i.get(),l.setStyle(n.getContainer(),"height",f+"px"),i.set(f),u(n),o.browser.isSafari()&&o.mac){var C=n.getWin();C.scrollTo(C.pageXOffset,C.pageYOffset)}n.hasFocus()&&n.selection.scrollIntoView(n.selection.getNode()),o.webkit&&r<0&&m(n,i)}}},d={setup:function(e,t){e.on("init",(function(){var t=f(e);e.dom.setStyles(e.getBody(),{paddingLeft:t,paddingRight:t,"min-height":0})})),e.on("NodeChange SetContent keyup FullscreenStateChanged ResizeContent",(function(){m(e,t)})),g(e)&&e.on("init",(function(){l(e,t,20,100,(function(){l(e,t,5,1e3)}))}))},resize:m},h=function(e,t){e.addCommand("mceAutoResize",(function(){d.resize(e,t)}))};i.add("autoresize",(function(e){if(e.settings.hasOwnProperty("resize")||(e.settings.resize=!1),!e.inline){var t=n(0);h(e,t),d.setup(e,t)}}))}();