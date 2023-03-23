!function(t){"use strict";function n(){}function r(t){return function(){return t}}function e(t){return t}function o(){return et}function a(t){return t.isNone()}function i(t){return t()}function u(t){return t}function f(t){return function(n){return function(t){if(null===t)return"null";var n=typeof t;return"object"==n&&(Array.prototype.isPrototypeOf(t)||t.constructor&&"Array"===t.constructor.name)?"array":"object"==n&&(String.prototype.isPrototypeOf(t)||t.constructor&&"String"===t.constructor.name)?"string":n}(n)===t}}function c(t,n){return-1<function(t,n){return lt.call(t,n)}(t,n)}function s(t,n){for(var r=t.length,e=new Array(r),o=0;o<r;o++){var a=t[o];e[o]=n(a,o)}return e}function l(t,n){for(var r=0,e=t.length;r<e;r++)n(t[r],r)}function d(t,n){for(var r=[],e=0,o=t.length;e<o;e++){var a=t[e];n(a,e)&&r.push(a)}return r}function m(t,n,r){return function(t,n){for(var r=t.length-1;0<=r;r--)n(t[r],r)}(t,(function(t){r=n(r,t)})),r}function g(t,n){for(var r=0,e=t.length;r<e;++r)if(!0!==n(t[r],r))return!1;return!0}function p(t){var n=[],r=[];return l(t,(function(t){t.fold((function(t){n.push(t)}),(function(t){r.push(t)}))})),{errors:n,values:r}}function h(t){return"inline-command"===t.type||"inline-format"===t.type}function v(t){return"block-command"===t.type||"block-format"===t.type}function y(t){return function(t,n){var r=st.call(t,0);return r.sort(n),r}(t,(function(t,n){return t.start.length===n.start.length?0:t.start.length>n.start.length?-1:1}))}function b(t){function n(n){return yt.error({message:n,pattern:t})}function r(r,e,o){if(void 0===t.format)return void 0!==t.cmd?it(t.cmd)?yt.value(o(t.cmd,t.value)):n(r+" pattern has non-string `cmd` parameter"):n(r+" pattern is missing both `format` and `cmd` parameters");var a=void 0;if(ft(t.format)){if(!g(t.format,it))return n(r+" pattern has non-string items in the `format` array");a=t.format}else{if(!it(t.format))return n(r+" pattern has non-string `format` parameter");a=[t.format]}return yt.value(e(a))}if(!ut(t))return n("Raw pattern is not an object");if(!it(t.start))return n("Raw pattern is missing `start` parameter");if(void 0===t.end)return void 0!==t.replacement?it(t.replacement)?0===t.start.length?n("Replacement pattern has empty `start` parameter"):yt.value({type:"inline-command",start:"",end:t.start,cmd:"mceInsertContent",value:t.replacement}):n("Replacement pattern has non-string `replacement` parameter"):0===t.start.length?n("Block pattern has empty `start` parameter"):r("Block",(function(n){return{type:"block-format",start:t.start,format:n[0]}}),(function(n,r){return{type:"block-command",start:t.start,cmd:n,value:r}}));if(!it(t.end))return n("Inline pattern has non-string `end` parameter");if(0===t.start.length&&0===t.end.length)return n("Inline pattern has empty `start` and `end` parameters");var e=t.start,o=t.end;return 0===o.length&&(o=e,e=""),r("Inline",(function(t){return{type:"inline-format",start:e,end:o,format:t}}),(function(t,n){return{type:"inline-command",start:e,end:o,cmd:t,value:n}}))}function k(t){return"block-command"===t.type?{start:t.start,cmd:t.cmd,value:t.value}:"block-format"===t.type?{start:t.start,format:t.format}:"inline-command"===t.type?"mceInsertContent"===t.cmd&&""===t.start?{start:t.end,replacement:t.value}:{start:t.start,end:t.end,cmd:t.cmd,value:t.value}:"inline-format"===t.type?{start:t.start,end:t.end,format:1===t.format.length?t.format[0]:t.format}:void 0}function O(t){return{inlinePatterns:d(t,h),blockPatterns:y(d(t,v))}}function w(){for(var t=[],n=0;n<arguments.length;n++)t[n]=arguments[n];var r=kt.console;r&&(r.error?r.error.apply(r,t):r.log.apply(r,t))}function x(t){var n=function(t,n){return gt(t,n)?at.from(t[n]):at.none()}(t,"textpattern_patterns").getOr(Ot);if(!ft(n))return w("The setting textpattern_patterns should be an array"),{inlinePatterns:[],blockPatterns:[]};var r=p(s(n,b));return l(r.errors,(function(t){return w(t.message,t.pattern)})),O(r.values)}function C(t){var n=t.getParam("forced_root_block","p");return!1===n?"":!0===n?"p":n}function E(n){return n.nodeType===t.Node.TEXT_NODE}function T(t,n,r,e){void 0===e&&(e=!0);var o=n.startContainer.parentNode,a=n.endContainer.parentNode;n.deleteContents(),e&&!r(n.startContainer)&&(E(n.startContainer)&&0===n.startContainer.data.length&&t.remove(n.startContainer),E(n.endContainer)&&0===n.endContainer.data.length&&t.remove(n.endContainer),Tt(t,o,r),o!==a&&Tt(t,a,r))}function R(t,n){var r=n.get(t);return ft(r)&&function(t){return 0===t.length?at.none():at.some(t[0])}(r).exists((function(t){return gt(t,"block")}))}function N(t){return 0===t.start.length}function P(t,n){var r=at.from(t.dom.getParent(n.startContainer,t.dom.isBlock));return""===C(t)?r.orThunk((function(){return at.some(t.getBody())})):r}function S(t,n){return{element:t,offset:n}}function M(n,r){function e(n){for(var r=o[n]();r&&r.nodeType!==t.Node.TEXT_NODE;)r=o[n]();return r&&r.nodeType===t.Node.TEXT_NODE?at.some(r):at.none()}var o=new Et(n,r);return{next:function(){return e("next")},prev:function(){return e("prev")},prev2:function(){return e("prev2")}}}function A(t,n,r){return E(t)&&0<=n?at.some(S(t,n)):M(t,r).prev().map((function(t){return S(t,t.data.length)}))}function j(t,n,r){if(E(n)&&(r<0||r>n.data.length))return[];for(var e=[r],o=n;o!==t&&o.parentNode;){for(var a=o.parentNode,i=0;i<a.childNodes.length;i++)if(a.childNodes[i]===o){e.push(i);break}o=a}return o===t?e.reverse():[]}function B(t,n,r,e,o){return{start:j(t,n,r),end:j(t,e,o)}}function D(t,n){var r=n.slice(),e=r.pop();return function(t,n,r){return l(t,(function(t){r=n(r,t)})),r}(r,(function(t,n){return t.bind((function(t){return at.from(t.childNodes[n])}))}),at.some(t)).bind((function(t){return E(t)&&0<=e&&t.data.length,at.some({node:t,offset:e})}))}function I(n,r){return D(n,r.start).bind((function(e){var o=e.node,a=e.offset;return D(n,r.end).map((function(n){var r=n.node,e=n.offset,i=t.document.createRange();return i.setStart(o,a),i.setEnd(r,e),i}))}))}function _(t,n,r){M(n,n).next().each((function(e){Nt(e,r.start.length,n).each((function(r){var o=t.createRng();o.setStart(e,0),o.setEnd(r.element,r.offset),T(t,o,(function(t){return t===n}))}))}))}function U(t,n){var r=n.replace("\xa0"," ");return function(t,n){for(var r=0,e=t.length;r<e;r++){var o=t[r];if(n(o,r))return at.some(o)}return at.none()}(t,(function(t){return 0===n.indexOf(t.start)||0===r.indexOf(t.start)}))}function q(t,n){if(0!==n.length){var r=t.selection.getBookmark();l(n,(function(n){return function(t,n){var r=t.dom,e=n.pattern,o=I(r.getRoot(),n.range).getOrDie("Unable to resolve path range");return P(t,o).each((function(n){"block-format"===e.type?R(e.format,t.formatter)&&t.undoManager.transact((function(){_(t.dom,n,e),t.formatter.apply(e.format)})):"block-command"===e.type&&t.undoManager.transact((function(){_(t.dom,n,e),t.execCommand(e.cmd,!1,e.value)}))})),!0}(t,n)})),t.selection.moveToBookmark(r)}}function L(t,n){return t.create("span",{"data-mce-type":"bookmark",id:n})}function V(t,n){var r=t.createRng();return r.setStartAfter(n.start),r.setEndBefore(n.end),r}function W(t,n,r){var e=I(t.getRoot(),r).getOrDie("Unable to resolve path range"),o=e.startContainer,a=e.endContainer,i=0===e.endOffset?a:a.splitText(e.endOffset),u=0===e.startOffset?o:o.splitText(e.startOffset);return{prefix:n,end:i.parentNode.insertBefore(L(t,n+"-end"),i),start:u.parentNode.insertBefore(L(t,n+"-start"),u)}}function X(t,n,r){Tt(t,t.get(n.prefix+"-end"),r),Tt(t,t.get(n.prefix+"-start"),r)}function z(t,n,r,e,o,a){if(void 0===a&&(a=!1),0!==n.start.length||a)return A(r,e,o).bind((function(r){return function(t,n,r,e,o){var a=new Et(n,o);return Mt(t,n,at.some(r),e,a.prev,at.none())}(t,r.element,r.offset,function(t,n,r){return function(e,o,a,i){if(o===n)return e.abort();var u=a.substring(0,i.getOr(a.length)),f=u.lastIndexOf(r.charAt(r.length-1)),c=u.lastIndexOf(r);if(-1===c)return-1!==f?Rt(o,f+1-r.length,n).fold((function(){return e.kontinue()}),(function(n){var a=t.createRng();return a.setStart(n.element,n.offset),a.setEnd(o,f+1),a.toString()===r?e.finish(a):e.kontinue()})):e.kontinue();var s=t.createRng();return s.setStart(o,c),s.setEnd(o,c+r.length),e.finish(s)}}(t,o,n.start),o).fold(at.none,at.none,at.some).bind((function(t){if(a){if(t.endContainer===r.element&&t.endOffset===r.offset)return at.none();if(0===r.offset&&t.endContainer.textContent.length===t.endOffset)return at.none()}return at.some(t)}))}));var i=t.createRng();return i.setStart(r,e),i.setEnd(r,e),at.some(i)}function F(t,n,r){var e=t.dom,o=e.getRoot(),a=r.pattern,i=r.position.element,u=r.position.offset;return Rt(i,u-r.pattern.end.length,n).bind((function(f){var c=B(o,f.element,f.offset,i,u);if(N(a))return at.some({matches:[{pattern:a,startRng:c,endRng:c}],position:f});var s=jt(t,r.remainingPatterns,f.element,f.offset,n),l=s.getOr({matches:[],position:f}),d=l.position;return z(e,a,d.element,d.offset,n,s.isNone()).map((function(t){var n=function(t,n){return B(t,n.startContainer,n.startOffset,n.endContainer,n.endOffset)}(o,t);return{matches:l.matches.concat([{pattern:a,startRng:n,endRng:c}]),position:S(t.startContainer,t.startOffset)}}))}))}function G(t,n,r){t.selection.setRng(r),"inline-format"===n.type?l(n.format,(function(n){t.formatter.apply(n)})):t.execCommand(n.cmd,!1,n.value)}function H(t,n){var r=function(t){var n=(new Date).getTime();return t+"_"+Math.floor(1e9*Math.random())+ ++At+String(n)}("mce_textpattern"),e=m(n,(function(n,e){var o=W(t,r+"_end"+n.length,e.endRng);return n.concat([tt(tt({},e),{endMarker:o})])}),[]);return m(e,(function(n,o){var a=e.length-n.length-1,i=N(o.pattern)?o.endMarker:W(t,r+"_start"+a,o.startRng);return n.concat([tt(tt({},o),{startMarker:i})])}),[])}function J(t,n,r){var e=t.selection.getRng();return!1===e.collapsed?[]:P(t,e).bind((function(o){var a=e.startOffset-(r?1:0);return jt(t,n,e.startContainer,a,o)})).fold((function(){return[]}),(function(t){return t.matches}))}function K(t,n){if(0!==n.length){var r=t.dom,e=t.selection.getBookmark();l(H(r,n),(function(n){function e(t){return t===o}var o=r.getParent(n.startMarker.start,r.isBlock);N(n.pattern)?function(t,n,r,e){var o=V(t.dom,r);T(t.dom,o,e),G(t,n,o)}(t,n.pattern,n.endMarker,e):function(t,n,r,e,o){var a=t.dom,i=V(a,e);T(a,V(a,r),o),T(a,i,o),G(t,n,V(a,{prefix:r.prefix,start:r.end,end:e.start}))}(t,n.pattern,n.startMarker,n.endMarker,e),X(r,n.endMarker,e),X(r,n.startMarker,e)})),t.selection.moveToBookmark(e)}}function Q(t,n,r){for(var e=0;e<t.length;e++)if(r(t[e],n))return!0}var Y,Z=function(t){function n(){return r}var r=t;return{get:n,set:function(t){r=t},clone:function(){return Z(n())}}},$=tinymce.util.Tools.resolve("tinymce.PluginManager"),tt=function(){return(tt=Object.assign||function(t){for(var n,r=1,e=arguments.length;r<e;r++)for(var o in n=arguments[r])Object.prototype.hasOwnProperty.call(n,o)&&(t[o]=n[o]);return t}).apply(this,arguments)},nt=r(!1),rt=r(!0),et=(Y={fold:function(t){return t()},is:nt,isSome:nt,isNone:rt,getOr:u,getOrThunk:i,getOrDie:function(t){throw new Error(t||"error: getOrDie called on none.")},getOrNull:r(null),getOrUndefined:r(void 0),or:u,orThunk:i,map:o,each:n,bind:o,exists:nt,forall:rt,filter:o,equals:a,equals_:a,toArray:function(){return[]},toString:r("none()")},Object.freeze&&Object.freeze(Y),Y),ot=function(t){function n(){return a}function e(n){return n(t)}var o=r(t),a={fold:function(n,r){return r(t)},is:function(n){return t===n},isSome:rt,isNone:nt,getOr:o,getOrThunk:o,getOrDie:o,getOrNull:o,getOrUndefined:o,or:n,orThunk:n,map:function(n){return ot(n(t))},each:function(n){n(t)},bind:e,exists:e,forall:e,filter:function(n){return n(t)?a:et},toArray:function(){return[t]},toString:function(){return"some("+t+")"},equals:function(n){return n.is(t)},equals_:function(n,r){return n.fold(nt,(function(n){return r(t,n)}))}};return a},at={some:ot,none:o,from:function(t){return null==t?et:ot(t)}},it=f("string"),ut=f("object"),ft=f("array"),ct=f("function"),st=Array.prototype.slice,lt=Array.prototype.indexOf,dt=(ct(Array.from)&&Array.from,Object.keys),mt=Object.hasOwnProperty,gt=function(t,n){return mt.call(t,n)},pt=function(n){if(!ft(n))throw new Error("cases must be an array");if(0===n.length)throw new Error("there must be at least one case");var r=[],e={};return l(n,(function(o,a){var i=dt(o);if(1!==i.length)throw new Error("one and only one name per case");var u=i[0],f=o[u];if(void 0!==e[u])throw new Error("duplicate key detected:"+u);if("cata"===u)throw new Error("cannot have a case named cata (sorry)");if(!ft(f))throw new Error("case arguments must be an array");r.push(u),e[u]=function(){var e=arguments.length;if(e!==f.length)throw new Error("Wrong number of arguments to case "+u+". Expected "+f.length+" ("+f+"), got "+e);for(var o=new Array(e),i=0;i<o.length;i++)o[i]=arguments[i];return{fold:function(){if(arguments.length!==n.length)throw new Error("Wrong number of arguments to fold. Expected "+n.length+", got "+arguments.length);return arguments[a].apply(null,o)},match:function(t){var n=dt(t);if(r.length!==n.length)throw new Error("Wrong number of arguments to match. Expected: "+r.join(",")+"\nActual: "+n.join(","));if(!g(r,(function(t){return c(n,t)})))throw new Error("Not all branches were specified when using match. Specified: "+n.join(", ")+"\nRequired: "+r.join(", "));return t[u].apply(null,o)},log:function(n){t.console.log(n,{constructors:r,constructor:u,params:o})}}}})),e},ht=(pt([{bothErrors:["error1","error2"]},{firstError:["error1","value2"]},{secondError:["value1","error2"]},{bothValues:["value1","value2"]}]),function(t){return{is:function(n){return t===n},isValue:rt,isError:nt,getOr:r(t),getOrThunk:r(t),getOrDie:r(t),or:function(){return ht(t)},orThunk:function(){return ht(t)},fold:function(n,r){return r(t)},map:function(n){return ht(n(t))},mapError:function(){return ht(t)},each:function(n){n(t)},bind:function(n){return n(t)},exists:function(n){return n(t)},forall:function(n){return n(t)},toOption:function(){return at.some(t)}}}),vt=function(t){return{is:nt,isValue:nt,isError:rt,getOr:e,getOrThunk:function(t){return t()},getOrDie:function(){return function(t){return function(){throw new Error(t)}}(String(t))()},or:function(t){return t},orThunk:function(t){return t()},fold:function(n){return n(t)},map:function(){return vt(t)},mapError:function(n){return vt(n(t))},each:n,bind:function(){return vt(t)},exists:nt,forall:rt,toOption:at.none}},yt={value:ht,error:vt,fromOption:function(t,n){return t.fold((function(){return vt(n)}),ht)}},bt=function(t){return{setPatterns:function(n){var r=p(s(n,b));if(0<r.errors.length){var e=r.errors[0];throw new Error(e.message+":\n"+JSON.stringify(e.pattern,null,2))}t.set(O(r.values))},getPatterns:function(){return function(){for(var t=0,n=0,r=arguments.length;n<r;n++)t+=arguments[n].length;var e=Array(t),o=0;for(n=0;n<r;n++)for(var a=arguments[n],i=0,u=a.length;i<u;i++,o++)e[o]=a[i];return e}(s(t.get().inlinePatterns,k),s(t.get().blockPatterns,k))}}},kt=void 0!==t.window?t.window:Function("return this;")(),Ot=[{start:"*",end:"*",format:"italic"},{start:"**",end:"**",format:"bold"},{start:"#",format:"h1"},{start:"##",format:"h2"},{start:"###",format:"h3"},{start:"####",format:"h4"},{start:"#####",format:"h5"},{start:"######",format:"h6"},{start:"1. ",cmd:"InsertOrderedList"},{start:"* ",cmd:"InsertUnorderedList"},{start:"- ",cmd:"InsertUnorderedList"}],wt=tinymce.util.Tools.resolve("tinymce.util.Delay"),xt=tinymce.util.Tools.resolve("tinymce.util.VK"),Ct=tinymce.util.Tools.resolve("tinymce.util.Tools"),Et=tinymce.util.Tools.resolve("tinymce.dom.TreeWalker"),Tt=function(t,n,r){if(n&&t.isEmpty(n)&&!r(n)){var e=n.parentNode;t.remove(n),Tt(t,e,r)}},Rt=function(t,n,r){if(!E(t))return at.none();var e=t.textContent;return 0<=n&&n<=e.length?at.some(S(t,n)):M(t,r).prev().bind((function(t){var e=t.textContent;return Rt(t,n+e.length,r)}))},Nt=function(t,n,r){if(!E(t))return at.none();var e=t.textContent;return n<=e.length?at.some(S(t,n)):M(t,r).next().bind((function(t){return Nt(t,n-e.length,r)}))},Pt=pt([{aborted:[]},{edge:["element"]},{success:["info"]}]),St=pt([{abort:[]},{kontinue:[]},{finish:["info"]}]),Mt=function(t,n,r,e,o,a){function i(){return a.fold(Pt.aborted,Pt.edge)}function u(){var r=o();return r?Mt(t,r,at.none(),e,o,at.some(n)):i()}if(function(t,n){return t.isBlock(n)||c(["BR","IMG","HR","INPUT"],n.nodeName)||"false"===t.getContentEditable(n)}(t,n))return i();if(E(n)){var f=n.textContent;return e(St,n,f,r).fold(Pt.aborted,(function(){return u()}),Pt.success)}return u()},At=0,jt=function(t,n,r,e,o){var a=t.dom;return A(r,e,a.getRoot()).bind((function(i){var u=a.createRng();u.setStart(o,0),u.setEnd(r,e);for(var f,c,s=u.toString(),l=0;l<n.length;l++){var d=n[l];if(function(t,n,r){return""===n||!(t.length<n.length)&&t.substr(r,r+n.length)===n}(f=s,c=d.end,f.length-c.length)){var m=n.slice();m.splice(l,1);var g=F(t,o,{pattern:d,remainingPatterns:m,position:i});if(g.isSome())return g}}return at.none()}))},Bt=function(t,n){if(!t.selection.isCollapsed())return!1;var r=J(t,n.inlinePatterns,!1),e=function(t,n){var r=t.dom,e=t.selection.getRng();return P(t,e).filter((function(n){var e=C(t),o=""===e&&r.is(n,"body")||r.is(n,e);return null!==n&&o})).bind((function(t){var e=t.textContent;return U(n,e).map((function(n){return Ct.trim(e).length===n.start.length?[]:[{pattern:n,range:B(r.getRoot(),t,0,t,0)}]}))})).getOr([])}(t,n.blockPatterns);return(0<e.length||0<r.length)&&(t.undoManager.add(),t.undoManager.extra((function(){t.execCommand("mceInsertNewLine")}),(function(){t.insertContent("\ufeff"),K(t,r),q(t,e);var n=t.selection.getRng(),o=A(n.startContainer,n.startOffset,t.dom.getRoot());t.execCommand("mceInsertNewLine"),o.each((function(n){"\ufeff"===n.element.data.charAt(n.offset-1)&&(n.element.deleteData(n.offset-1,1),Tt(t.dom,n.element.parentNode,(function(n){return n===t.dom.getRoot()})))}))})),!0)},Dt=function(t,n){var r=J(t,n.inlinePatterns,!0);0<r.length&&t.undoManager.transact((function(){K(t,r)}))},It=function(t,n){return Q(t,n,(function(t,n){return t.charCodeAt(0)===n.charCode}))},_t=function(t,n){return Q(t,n,(function(t,n){return t===n.keyCode&&!1===xt.modifierPressed(n)}))},Ut=function(t,n){var r=[",",".",";",":","!","?"],e=[32];t.on("keydown",(function(r){13!==r.keyCode||xt.modifierPressed(r)||Bt(t,n.get())&&r.preventDefault()}),!0),t.on("keyup",(function(r){_t(e,r)&&Dt(t,n.get())})),t.on("keypress",(function(e){It(r,e)&&wt.setEditorTimeout(t,(function(){Dt(t,n.get())}))}))};$.add("textpattern",(function(t){var n=Z(x(t.settings));return Ut(t,n),bt(n)}))}(window);