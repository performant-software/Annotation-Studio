!function(n){"use strict";function t(n){return function(t){return function(n){if(null===n)return"null";var t=typeof n;return"object"==t&&(Array.prototype.isPrototypeOf(n)||n.constructor&&"Array"===n.constructor.name)?"array":"object"==t&&(String.prototype.isPrototypeOf(n)||n.constructor&&"String"===n.constructor.name)?"string":t}(t)===n}}function e(){}function r(n){return function(){return n}}function o(){return Z}function i(n){return n.isNone()}function u(n){return n()}function c(n){return n}function a(n,t){return-1<function(n,t){return en.call(n,t)}(n,t)}function f(n,t){for(var e=0,r=n.length;e<r;e++)t(n[e],e)}function l(n){for(var t=[],e=0,r=n.length;e<r;++e){if(!R(n[e]))throw new Error("Arr.flatten item "+e+" was not an array, input: "+n);rn.apply(t,n[e])}return t}function s(n,t){var e=function(n,t){for(var e=n.length,r=new Array(e),o=0;o<e;o++){var i=n[o];r[o]=t(i,o)}return r}(n,t);return l(e)}function m(n){return/^\w+:/i.test(n)}function d(n,t){var e,r,o=["noopener"],i=n?n.split(/\s+/):[],u=function(n){return n.filter((function(n){return-1===on.inArray(o,n)}))},c=t?0<(e=u(e=i)).length?e.concat(o):o:u(i);return 0<c.length?(r=c,on.trim(r.sort().join(" "))):""}function h(n,t){return t=t||n.selection.getNode(),un(t)?n.dom.select("a[href]",t)[0]:n.dom.getParent(t,"a[href]")}function p(n){return n&&"A"===n.nodeName&&!!n.href}function g(n){return function(n,t,e){return f(n,(function(n){e=t(e,n)})),e}(["title","rel","class","target"],(function(t,e){return n[e].each((function(n){t[e]=0<n.length?n:null})),t}),{href:n.href})}function v(n,t){var e=X({},t);if(!(0<V(n).length)&&!1===$(n)){var r=d(e.rel,"_blank"===e.target);e.rel=r||null}return tn.from(e.target).isNone()&&!1===B(n)&&(e.target=K(n)),e.href=function(n,t){return"http"!==t&&"https"!==t||m(n)?n:t+"://"+n}(e.href,M(n)),e}function y(n,t){for(var e=0;e<n.length;e++){var r=t(n[e],e);if(r.isSome())return r}return tn.none()}function w(n){return L(n.value)?n.value:""}function x(n){return void 0===n&&(n=w),function(t){return tn.from(t).map((function(t){return function(n,t){var e=[];return on.each(n,(function(n){var r=L(n.text)?n.text:L(n.title)?n.title:"";if(void 0!==n.menu);else{var o=t(n);e.push({text:r,value:o})}})),e}(t,n)}))}}function k(n,t,r,o){var i=o[t],u=0<n.length;return void 0!==i?function(n,t){return y(t,(function(t){return tn.some(t).filter((function(t){return t.value===n}))}))}(i,r).map((function(t){return{url:{value:t.value,meta:{text:u?n:t.text,attach:e}},text:u?n:t.text}})):tn.none()}function b(t){n.setTimeout((function(){throw t}),0)}function _(n){var t=n.href;return 0<t.indexOf("@")&&-1===t.indexOf("//")&&-1===t.indexOf("mailto:")?tn.some({message:"The URL you entered seems to be an email address. Do you want to add the required mailto: prefix?",preprocess:function(n){return X(X({},n),{href:"mailto:"+t})}}):tn.none()}function T(n,t,e){var r=n.getAttrib(t,e);return null!==r&&0<r.length?tn.some(r):tn.none()}function O(n,t){return n.dom.getParent(t,"a[href]")}function A(n){return O(n,n.selection.getStart())}function C(n,t){if(t){var e=mn(t);if(/^#/.test(e)){var r=n.$(e);r.length&&n.selection.scrollIntoView(r[0],!0)}else J(t.href)}}var P,N,E,I,S,j=tinymce.util.Tools.resolve("tinymce.PluginManager"),F=tinymce.util.Tools.resolve("tinymce.util.VK"),L=t("string"),R=t("array"),D=t("boolean"),U=t("function"),M=function(n){var t=n.getParam("link_assume_external_targets",!1);return D(t)&&t?1:!L(t)||"http"!==t&&"https"!==t?0:t},z=function(n){return n.getParam("link_context_toolbar",!1,"boolean")},q=function(n){return n.getParam("link_list")},K=function(n){return n.getParam("default_link_target")},B=function(n){return n.getParam("target_list",!0)},V=function(n){return n.getParam("rel_list",[],"array")},W=function(n){return n.getParam("link_class_list",[],"array")},H=function(n){return n.getParam("link_title",!0,"boolean")},$=function(n){return n.getParam("allow_unsafe_link_target",!1,"boolean")},G=function(n){return n.getParam("link_quicklink",!1,"boolean")},J=function(t){var e=n.document.createElement("a");e.target="_blank",e.href=t,e.rel="noreferrer noopener";var r=n.document.createEvent("MouseEvents");r.initMouseEvent("click",!0,!0,n.window,0,0,0,0,0,!1,!1,!1,!1,0,null),function(t,e){n.document.body.appendChild(t),t.dispatchEvent(e),n.document.body.removeChild(t)}(e,r)},X=function(){return(X=Object.assign||function(n){for(var t,e=1,r=arguments.length;e<r;e++)for(var o in t=arguments[e])Object.prototype.hasOwnProperty.call(t,o)&&(n[o]=t[o]);return n}).apply(this,arguments)},Q=r(!1),Y=r(!0),Z=(P={fold:function(n){return n()},is:Q,isSome:Q,isNone:Y,getOr:c,getOrThunk:u,getOrDie:function(n){throw new Error(n||"error: getOrDie called on none.")},getOrNull:r(null),getOrUndefined:r(void 0),or:c,orThunk:u,map:o,each:e,bind:o,exists:Q,forall:Y,filter:o,equals:i,equals_:i,toArray:function(){return[]},toString:r("none()")},Object.freeze&&Object.freeze(P),P),nn=function(n){function t(){return i}function e(t){return t(n)}var o=r(n),i={fold:function(t,e){return e(n)},is:function(t){return n===t},isSome:Y,isNone:Q,getOr:o,getOrThunk:o,getOrDie:o,getOrNull:o,getOrUndefined:o,or:t,orThunk:t,map:function(t){return nn(t(n))},each:function(t){t(n)},bind:e,exists:e,forall:e,filter:function(t){return t(n)?i:Z},toArray:function(){return[n]},toString:function(){return"some("+n+")"},equals:function(t){return t.is(n)},equals_:function(t,e){return t.fold(Q,(function(t){return e(n,t)}))}};return i},tn={some:nn,none:o,from:function(n){return null==n?Z:nn(n)}},en=(Array.prototype.slice,Array.prototype.indexOf),rn=Array.prototype.push,on=(U(Array.from)&&Array.from,tinymce.util.Tools.resolve("tinymce.util.Tools")),un=function(n){return n&&"FIGURE"===n.nodeName&&/\bimage\b/i.test(n.className)},cn=function(n,t){var e=n.dom.select("img",t)[0];if(e){var r=n.dom.getParents(e,"a[href]",t)[0];r&&(r.parentNode.insertBefore(e,r),n.dom.remove(r))}},an=function(n,t,e){var r=n.dom.select("img",t)[0];if(r){var o=n.dom.create("a",e);r.parentNode.insertBefore(o,r),o.appendChild(r)}},fn=function(n,t,e){var r=n.selection.getNode(),o=h(n,r),i=v(n,g(e));n.undoManager.transact((function(){e.href===t.href&&t.attach(),o?(n.focus(),function(n,t,e,r){e.each((function(n){t.hasOwnProperty("innerText")?t.innerText=n:t.textContent=n})),n.dom.setAttribs(t,r),n.selection.select(t)}(n,o,e.text,i)):function(n,t,e,r){un(t)?an(n,t,r):e.fold((function(){n.execCommand("mceInsertLink",!1,r)}),(function(t){n.insertContent(n.dom.createHTML("a",r,n.dom.encode(t)))}))}(n,r,e.text,i)}))},ln=function(n){n.undoManager.transact((function(){var t=n.selection.getNode();if(un(t))cn(n,t);else{var e=n.dom.getParent(t,"a[href]",n.getBody());e&&n.dom.remove(e,!0)}n.focus()}))},sn=function(n){return 0<on.grep(n,p).length},mn=function(n){return n.getAttribute("data-mce-href")||n.getAttribute("href")},dn=function(n){return!(/</.test(n)&&(!/^<a [^>]+>[^<]+<\/a>$/.test(n)||-1===n.indexOf("href=")))},hn=h,pn=function(n,t){return function(n){return n.replace(/\uFEFF/g,"")}(t?t.innerText||t.textContent:n.getContent({format:"text"}))},gn=d,vn=m,yn={sanitize:function(n){return x(w)(n)},sanitizeWith:x,createUi:function(n,t){return function(e){return{name:n,type:"selectbox",label:t,items:e}}},getValue:w},wn=function(n){function t(){return e}var e=n;return{get:t,set:function(n){e=n},clone:function(){return wn(t())}}},xn=function(n,t){function e(n,e){var o=function(n,t){return"link"===t?n.catalogs.link:"anchor"===t?n.catalogs.anchor:tn.none()}(t,e.name).getOr([]);return k(r.get(),e.name,o,n)}var r=wn(n.text);return{onChange:function(n,t){return"url"===t.name?function(n){if(r.get().length<=0){var t=void 0!==n.url.meta.text?n.url.meta.text:n.url.value;return tn.some({text:t})}return tn.none()}(n()):a(["anchor","link"],t.name)?e(n(),t):("text"===t.name&&r.set(n().text),tn.none())}}},kn={},bn={exports:kn};N=void 0,E=kn,I=bn,S=void 0,function(n){"object"==typeof E&&void 0!==I?I.exports=n():"function"==typeof N&&N.amd?N([],n):("undefined"!=typeof window?window:"undefined"!=typeof global?global:"undefined"!=typeof self?self:this).EphoxContactWrapper=n()}((function(){return function n(t,e,r){function o(u,c){if(!e[u]){if(!t[u]){var a="function"==typeof S&&S;if(!c&&a)return a(u,!0);if(i)return i(u,!0);var f=new Error("Cannot find module '"+u+"'");throw f.code="MODULE_NOT_FOUND",f}var l=e[u]={exports:{}};t[u][0].call(l.exports,(function(n){return o(t[u][1][n]||n)}),l,l.exports,n,t,e,r)}return e[u].exports}for(var i="function"==typeof S&&S,u=0;u<r.length;u++)o(r[u]);return o}({1:[function(n,t){function e(){throw new Error("setTimeout has not been defined")}function r(){throw new Error("clearTimeout has not been defined")}function o(n){if(f===setTimeout)return setTimeout(n,0);if((f===e||!f)&&setTimeout)return f=setTimeout,setTimeout(n,0);try{return f(n,0)}catch(t){try{return f.call(null,n,0)}catch(t){return f.call(this,n,0)}}}function i(){h&&m&&(h=!1,m.length?d=m.concat(d):p=-1,d.length&&u())}function u(){if(!h){var n=o(i);h=!0;for(var t=d.length;t;){for(m=d,d=[];++p<t;)m&&m[p].run();p=-1,t=d.length}m=null,h=!1,function(n){if(l===clearTimeout)return clearTimeout(n);if((l===r||!l)&&clearTimeout)return l=clearTimeout,clearTimeout(n);try{return l(n)}catch(t){try{return l.call(null,n)}catch(t){return l.call(this,n)}}}(n)}}function c(n,t){this.fun=n,this.array=t}function a(){}var f,l,s=t.exports={};!function(){try{f="function"==typeof setTimeout?setTimeout:e}catch(n){f=e}try{l="function"==typeof clearTimeout?clearTimeout:r}catch(n){l=r}}();var m,d=[],h=!1,p=-1;s.nextTick=function(n){var t=new Array(arguments.length-1);if(1<arguments.length)for(var e=1;e<arguments.length;e++)t[e-1]=arguments[e];d.push(new c(n,t)),1!==d.length||h||o(u)},c.prototype.run=function(){this.fun.apply(null,this.array)},s.title="browser",s.browser=!0,s.env={},s.argv=[],s.version="",s.versions={},s.on=a,s.addListener=a,s.once=a,s.off=a,s.removeListener=a,s.removeAllListeners=a,s.emit=a,s.prependListener=a,s.prependOnceListener=a,s.listeners=function(){return[]},s.binding=function(){throw new Error("process.binding is not supported")},s.cwd=function(){return"/"},s.chdir=function(){throw new Error("process.chdir is not supported")},s.umask=function(){return 0}},{}],2:[function(n,t){(function(n){function e(){}function r(n){if("object"!=typeof this)throw new TypeError("Promises must be constructed via new");if("function"!=typeof n)throw new TypeError("not a function");this._state=0,this._handled=!1,this._value=void 0,this._deferreds=[],f(n,this)}function o(n,t){for(;3===n._state;)n=n._value;0!==n._state?(n._handled=!0,r._immediateFn((function(){var e=1===n._state?t.onFulfilled:t.onRejected;if(null!==e){var r;try{r=e(n._value)}catch(n){return void u(t.promise,n)}i(t.promise,r)}else(1===n._state?i:u)(t.promise,n._value)}))):n._deferreds.push(t)}function i(n,t){try{if(t===n)throw new TypeError("A promise cannot be resolved with itself.");if(t&&("object"==typeof t||"function"==typeof t)){var e=t.then;if(t instanceof r)return n._state=3,n._value=t,void c(n);if("function"==typeof e)return void f(function(n,t){return function(){n.apply(t,arguments)}}(e,t),n)}n._state=1,n._value=t,c(n)}catch(t){u(n,t)}}function u(n,t){n._state=2,n._value=t,c(n)}function c(n){2===n._state&&0===n._deferreds.length&&r._immediateFn((function(){n._handled||r._unhandledRejectionFn(n._value)}));for(var t=0,e=n._deferreds.length;t<e;t++)o(n,n._deferreds[t]);n._deferreds=null}function a(n,t,e){this.onFulfilled="function"==typeof n?n:null,this.onRejected="function"==typeof t?t:null,this.promise=e}function f(n,t){var e=!1;try{n((function(n){e||(e=!0,i(t,n))}),(function(n){e||(e=!0,u(t,n))}))}catch(n){if(e)return;e=!0,u(t,n)}}var l,s;l=this,s=setTimeout,r.prototype.catch=function(n){return this.then(null,n)},r.prototype.then=function(n,t){var r=new this.constructor(e);return o(this,new a(n,t,r)),r},r.all=function(n){var t=Array.prototype.slice.call(n);return new r((function(n,e){function r(i,u){try{if(u&&("object"==typeof u||"function"==typeof u)){var c=u.then;if("function"==typeof c)return void c.call(u,(function(n){r(i,n)}),e)}t[i]=u,0==--o&&n(t)}catch(n){e(n)}}if(0===t.length)return n([]);for(var o=t.length,i=0;i<t.length;i++)r(i,t[i])}))},r.resolve=function(n){return n&&"object"==typeof n&&n.constructor===r?n:new r((function(t){t(n)}))},r.reject=function(n){return new r((function(t,e){e(n)}))},r.race=function(n){return new r((function(t,e){for(var r=0,o=n.length;r<o;r++)n[r].then(t,e)}))},r._immediateFn="function"==typeof n?function(t){n(t)}:function(n){s(n,0)},r._unhandledRejectionFn=function(n){"undefined"!=typeof console&&console&&console.warn("Possible Unhandled Promise Rejection:",n)},r._setImmediateFn=function(n){r._immediateFn=n},r._setUnhandledRejectionFn=function(n){r._unhandledRejectionFn=n},void 0!==t&&t.exports?t.exports=r:l.Promise||(l.Promise=r)}).call(this,n("timers").setImmediate)},{timers:3}],3:[function(n,t,e){(function(t,r){function o(n,t){this._id=n,this._clearFn=t}var i=n("process/browser.js").nextTick,u=Function.prototype.apply,c=Array.prototype.slice,a={},f=0;e.setTimeout=function(){return new o(u.call(setTimeout,window,arguments),clearTimeout)},e.setInterval=function(){return new o(u.call(setInterval,window,arguments),clearInterval)},e.clearTimeout=e.clearInterval=function(n){n.close()},o.prototype.unref=o.prototype.ref=function(){},o.prototype.close=function(){this._clearFn.call(window,this._id)},e.enroll=function(n,t){clearTimeout(n._idleTimeoutId),n._idleTimeout=t},e.unenroll=function(n){clearTimeout(n._idleTimeoutId),n._idleTimeout=-1},e._unrefActive=e.active=function(n){clearTimeout(n._idleTimeoutId);var t=n._idleTimeout;0<=t&&(n._idleTimeoutId=setTimeout((function(){n._onTimeout&&n._onTimeout()}),t))},e.setImmediate="function"==typeof t?t:function(n){var t=f++,r=!(arguments.length<2)&&c.call(arguments,1);return a[t]=!0,i((function(){a[t]&&(r?n.apply(null,r):n.call(null),e.clearImmediate(t))})),t},e.clearImmediate="function"==typeof r?r:function(n){delete a[n]}}).call(this,n("timers").setImmediate,n("timers").clearImmediate)},{"process/browser.js":1,timers:3}],4:[function(n,t){var e=n("promise-polyfill"),r="undefined"!=typeof window?window:Function("return this;")();t.exports={boltExport:r.Promise||e}},{"promise-polyfill":2}]},{},[4])(4)}));var _n=bn.exports.boltExport,Tn=function(t){var e=tn.none(),r=[],o=function(n){i()?c(n):r.push(n)},i=function(){return e.isSome()},u=function(n){f(n,c)},c=function(t){e.each((function(e){n.setTimeout((function(){t(e)}),0)}))};return t((function(n){e=tn.some(n),u(r),r=[]})),{get:o,map:function(n){return Tn((function(t){o((function(e){t(n(e))}))}))},isReady:i}},On={nu:Tn,pure:function(n){return Tn((function(t){t(n)}))}},An=function(n){function t(t){n().then(t,b)}return{map:function(t){return An((function(){return n().then(t)}))},bind:function(t){return An((function(){return n().then((function(n){return t(n).toPromise()}))}))},anonBind:function(t){return An((function(){return n().then((function(){return t.toPromise()}))}))},toLazy:function(){return On.nu(t)},toCached:function(){var t=null;return An((function(){return null===t&&(t=n()),t}))},toPromise:n,get:t}},Cn=function(n){return An((function(){return new _n(n)}))},Pn=function(n){return An((function(){return _n.resolve(n)}))},Nn=tinymce.util.Tools.resolve("tinymce.util.Delay"),En=function(n,t,e){return y([_,function(n){return function(t){var e=t.href;return 1===n&&!vn(e)||0===n&&/^\s*www[\.|\d\.]/i.test(e)?tn.some({message:"The URL you entered seems to be an external link. Do you want to add the required http:// prefix?",preprocess:function(n){return X(X({},n),{href:"http://"+e})}}):tn.none()}}(t)],(function(n){return n(e)})).fold((function(){return Pn(e)}),(function(t){return Cn((function(r){!function(n,t,e){var r=n.selection.getRng();Nn.setEditorTimeout(n,(function(){n.windowManager.confirm(t,(function(t){n.selection.setRng(r),e(t)}))}))}(n,t.message,(function(n){r(n?t.preprocess(e):e)}))}))}))},In=function(n){var t=s(n.dom.select("a:not([href])"),(function(n){var t=n.name||n.id;return t?[{text:t,value:"#"+t}]:[]}));return 0<t.length?tn.some([{text:"None",value:""}].concat(t)):tn.none()},Sn=function(n){var t=W(n);return 0<t.length?yn.sanitize(t):tn.none()},jn=tinymce.util.Tools.resolve("tinymce.util.XHR"),Fn=function(n){function t(t){return n.convertURL(t.value||t.url,"href")}var e=q(n);return Cn((function(n){L(e)?jn.send({url:e,success:function(t){return n(function(n){try{return tn.some(JSON.parse(n))}catch(n){return tn.none()}}(t))},error:function(){return n(tn.none())}}):U(e)?e((function(t){return n(tn.some(t))})):n(tn.from(e))})).map((function(n){return n.bind(yn.sanitizeWith(t)).map((function(n){return 0<n.length?[{text:"None",value:""}].concat(n):n}))}))},Ln=function(n,t){var e=V(n);if(0<e.length){var r=t.is("_blank");return(!1===$(n)?yn.sanitizeWith((function(n){return gn(yn.getValue(n),r)})):yn.sanitize)(e)}return tn.none()},Rn=[{text:"Current window",value:""},{text:"New window",value:"_blank"}],Dn=function(n){var t=B(n);return R(t)?yn.sanitize(t).orThunk((function(){return tn.some(Rn)})):!1===t?tn.none():tn.some(Rn)},Un=function(n,t){return Fn(n).map((function(e){var r=function(n,t){var e=n.dom,r=dn(n.selection.getContent())?tn.some(pn(n.selection,t)):tn.none(),o=t?tn.some(e.getAttrib(t,"href")):tn.none(),i=t?tn.from(e.getAttrib(t,"target")):tn.none(),u=T(e,t,"rel"),c=T(e,t,"class");return{url:o,text:r,title:T(e,t,"title"),target:i,rel:u,linkClass:c}}(n,t);return{anchor:r,catalogs:{targets:Dn(n),rels:Ln(n,r.target),classes:Sn(n),anchor:In(n),link:e},optNode:tn.from(t),flags:{titleEnabled:H(n)}}}))},Mn=function(n){(function(n){var t=hn(n);return Un(n,t)})(n).map((function(t){return function(n,t,e){var r=n.anchor.text.map((function(){return{name:"text",type:"input",label:"Text to display"}})).toArray(),o=n.flags.titleEnabled?[{name:"title",type:"input",label:"Title"}]:[],i=function(n,t){return{url:{value:n.anchor.url.getOr(""),meta:{attach:function(){},text:n.anchor.url.fold((function(){return""}),(function(){return n.anchor.text.getOr("")})),original:{value:n.anchor.url.getOr("")}}},text:n.anchor.text.getOr(""),title:n.anchor.title.getOr(""),anchor:n.anchor.url.getOr(""),link:n.anchor.url.getOr(""),rel:n.anchor.rel.getOr(""),target:n.anchor.target.or(t).getOr(""),linkClass:n.anchor.linkClass.getOr("")}}(n,tn.from(K(e))),u=xn(i,n),c=n.catalogs;return{title:"Insert/Edit Link",size:"normal",body:{type:"panel",items:l([[{name:"url",type:"urlinput",filetype:"file",label:"URL"}],r,o,function(n){for(var t=[],e=function(n){t.push(n)},r=0;r<n.length;r++)n[r].each(e);return t}([c.anchor.map(yn.createUi("anchor","Anchors")),c.rels.map(yn.createUi("rel","Rel")),c.targets.map(yn.createUi("target","Open link in...")),c.link.map(yn.createUi("link","Link list")),c.classes.map(yn.createUi("linkClass","Class"))])])},buttons:[{type:"cancel",name:"cancel",text:"Cancel"},{type:"submit",name:"save",text:"Save",primary:!0}],initialData:i,onChange:function(n,t){var e=t.name;u.onChange(n.getData,{name:e}).each((function(t){n.setData(t)}))},onSubmit:t}}(t,function(n,t,e){return function(r){function o(n){return tn.from(i[n]).filter((function(e){return!t.anchor[n].is(e)}))}var i=r.getData();if(!i.url.value)return ln(n),void r.close();var u={href:i.url.value,text:o("text"),target:o("target"),rel:o("rel"),class:o("linkClass"),title:o("title")},c={href:i.url.value,attach:void 0!==i.url.meta&&i.url.meta.attach?i.url.meta.attach:function(){}};En(n,e,u).get((function(t){fn(n,c,t)})),r.close()}}(n,t,M(n)),n)})).get((function(t){n.windowManager.open(t)}))},zn=function(n){return function(){Mn(n)}},qn=function(n){return function(){C(n,A(n))}},Kn=function(n){n.on("click",(function(t){var e=O(n,t.target);e&&F.metaKeyPressed(t)&&(t.preventDefault(),C(n,e))})),n.on("keydown",(function(t){var e=A(n);e&&13===t.keyCode&&function(n){return!0===n.altKey&&!1===n.shiftKey&&!1===n.ctrlKey&&!1===n.metaKey}(t)&&(t.preventDefault(),C(n,e))}))},Bn=function(n){return function(t){function e(e){return t.setActive(!n.readonly&&!!hn(n,e.element))}return n.on("NodeChange",e),function(){return n.off("NodeChange",e)}}},Vn=function(n){return function(t){function e(n){return t.setDisabled(!sn(n.parents))}return t.setDisabled(!sn(n.dom.getParents(n.selection.getStart()))),n.on("NodeChange",e),function(){return n.off("NodeChange",e)}}},Wn=function(n){n.addCommand("mceLink",(function(){G(n)?n.fire("contexttoolbar-show",{toolbarKey:"quicklink"}):zn(n)()}))},Hn=function(n){n.addShortcut("Meta+K","",(function(){n.execCommand("mceLink")}))},$n=function(n){n.ui.registry.addToggleButton("link",{icon:"link",tooltip:"Insert/edit link",onAction:zn(n),onSetup:Bn(n)}),n.ui.registry.addButton("openlink",{icon:"new-tab",tooltip:"Open link",onAction:qn(n),onSetup:Vn(n)}),n.ui.registry.addButton("unlink",{icon:"unlink",tooltip:"Remove link",onAction:function(){return ln(n)},onSetup:Vn(n)})},Gn=function(n){n.ui.registry.addMenuItem("openlink",{text:"Open link",icon:"new-tab",onAction:qn(n),onSetup:Vn(n)}),n.ui.registry.addMenuItem("link",{icon:"link",text:"Link...",shortcut:"Meta+K",onAction:zn(n)}),n.ui.registry.addMenuItem("unlink",{icon:"unlink",text:"Remove link",onAction:function(){return ln(n)},onSetup:Vn(n)})},Jn=function(n){n.ui.registry.addContextMenu("link",{update:function(t){return sn(n.dom.getParents(t,"a"))?"link unlink openlink":"link"}})},Xn=function(n){function t(t){var e=n.selection.getNode();return t.setDisabled(!hn(n,e)),function(){}}n.ui.registry.addContextForm("quicklink",{launch:{type:"contextformtogglebutton",icon:"link",tooltip:"Link",onSetup:Bn(n)},label:"Link",predicate:function(t){return!!hn(n,t)&&z(n)},initValue:function(){var t=hn(n);return t?mn(t):""},commands:[{type:"contextformtogglebutton",icon:"link",tooltip:"Link",primary:!0,onSetup:function(t){var e=n.selection.getNode();return t.setActive(!!hn(n,e)),Bn(n)(t)},onAction:function(t){var e=hn(n),r=t.getValue();if(e)n.dom.setAttrib(e,"href",r),function(n){n.selection.collapse(!1)}(n),t.hide();else{var o={href:r,attach:function(){}},i=dn(n.selection.getContent())?tn.some(pn(n.selection,e)).filter((function(n){return 0<n.length})).or(tn.from(r)):tn.none();fn(n,o,{href:r,text:i,title:tn.none(),rel:tn.none(),target:tn.none(),class:tn.none()}),t.hide()}}},{type:"contextformbutton",icon:"unlink",tooltip:"Remove link",onSetup:t,onAction:function(t){ln(n),t.hide()}},{type:"contextformbutton",icon:"new-tab",tooltip:"Open link",onSetup:t,onAction:function(t){qn(n)(),t.hide()}}]})};j.add("link",(function(n){$n(n),Gn(n),Jn(n),Xn(n),Kn(n),Wn(n),Hn(n)}))}(window);