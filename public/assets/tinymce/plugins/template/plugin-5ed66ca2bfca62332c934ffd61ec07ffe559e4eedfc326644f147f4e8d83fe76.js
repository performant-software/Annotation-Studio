/**
 * TinyMCE version 6.2.0 (2022-09-08)
 */

!function(){"use strict";var e=tinymce.util.Tools.resolve("tinymce.PluginManager");const t=e=>t=>(e=>{const t=typeof e;return null===e?"null":"object"===t&&Array.isArray(e)?"array":"object"===t&&(a=n=e,(r=String).prototype.isPrototypeOf(a)||(null===(s=n.constructor)||void 0===s?void 0:s.name)===r.name)?"string":t;var a,n,r,s})(t)===e,a=t("string"),n=t("object"),r=t("array"),s=("function",e=>"function"==typeof e);const l=(!1,()=>false);var o=tinymce.util.Tools.resolve("tinymce.util.Tools");const c=e=>t=>t.options.get(e),i=c("template_cdate_classes"),u=c("template_mdate_classes"),m=c("template_selected_content_classes"),p=c("template_preview_replace_values"),d=c("template_replace_values"),h=c("templates"),g=c("template_cdate_format"),v=c("template_mdate_format"),f=c("content_style"),y=c("content_css_cors"),_=c("body_class"),b=(e,t)=>{if((e=""+e).length<t)for(let a=0;a<t-e.length;a++)e="0"+e;return e},M=(e,t,a=new Date)=>{const n="Sun Mon Tue Wed Thu Fri Sat Sun".split(" "),r="Sunday Monday Tuesday Wednesday Thursday Friday Saturday Sunday".split(" "),s="Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec".split(" "),l="January February March April May June July August September October November December".split(" ");return(t=(t=(t=(t=(t=(t=(t=(t=(t=(t=(t=(t=(t=(t=(t=t.replace("%D","%m/%d/%Y")).replace("%r","%I:%M:%S %p")).replace("%Y",""+a.getFullYear())).replace("%y",""+a.getYear())).replace("%m",b(a.getMonth()+1,2))).replace("%d",b(a.getDate(),2))).replace("%H",""+b(a.getHours(),2))).replace("%M",""+b(a.getMinutes(),2))).replace("%S",""+b(a.getSeconds(),2))).replace("%I",""+((a.getHours()+11)%12+1))).replace("%p",a.getHours()<12?"AM":"PM")).replace("%B",""+e.translate(l[a.getMonth()]))).replace("%b",""+e.translate(s[a.getMonth()]))).replace("%A",""+e.translate(r[a.getDay()]))).replace("%a",""+e.translate(n[a.getDay()]))).replace("%%","%")};class T{constructor(e,t){this.tag=e,this.value=t}static some(e){return new T(!0,e)}static none(){return T.singletonNone}fold(e,t){return this.tag?t(this.value):e()}isSome(){return this.tag}isNone(){return!this.tag}map(e){return this.tag?T.some(e(this.value)):T.none()}bind(e){return this.tag?e(this.value):T.none()}exists(e){return this.tag&&e(this.value)}forall(e){return!this.tag||e(this.value)}filter(e){return!this.tag||e(this.value)?this:T.none()}getOr(e){return this.tag?this.value:e}or(e){return this.tag?this:e}getOrThunk(e){return this.tag?this.value:e()}orThunk(e){return this.tag?this:e()}getOrDie(e){if(this.tag)return this.value;throw new Error(null!=e?e:"Called getOrDie on None")}static from(e){return null==e?T.none():T.some(e)}getOrNull(){return this.tag?this.value:null}getOrUndefined(){return this.value}each(e){this.tag&&e(this.value)}toArray(){return this.tag?[this.value]:[]}toString(){return this.tag?`some(${this.value})`:"none()"}}T.singletonNone=new T(!1);const x=Object.hasOwnProperty,S={'"':"&quot;","<":"&lt;",">":"&gt;","&":"&amp;","'":"&#039;"},w=e=>e.replace(/["'<>&]/g,(e=>{return(t=S,a=e,((e,t)=>x.call(e,t))(t,a)?T.from(t[a]):T.none()).getOr(e);var t,a})),C=(e,t,a)=>((a,n)=>{for(let n=0,s=a.length;n<s;n++)if(r=a[n],e.hasClass(t,r))return!0;var r;return!1})(a.split(/\s+/)),O=(e,t)=>(o.each(t,((t,a)=>{s(t)&&(t=t(a)),e=e.replace(new RegExp("\\{\\$"+a.replace(/[.*+?^${}()|[\]\\]/g,"\\$&")+"\\}","g"),t)})),e),A=(e,t)=>{const a=e.dom,n=d(e);o.each(a.select("*",t),(e=>{o.each(n,((t,n)=>{a.hasClass(e,n)&&s(t)&&t(e)}))}))},D=(e,t,a)=>{const n=e.dom,r=e.selection.getContent();a=O(a,d(e));let s=n.create("div",{},a);const l=n.select(".mceTmpl",s);l&&l.length>0&&(s=n.create("div"),s.appendChild(l[0].cloneNode(!0))),o.each(n.select("*",s),(t=>{C(n,t,i(e))&&(t.innerHTML=M(e,g(e))),C(n,t,u(e))&&(t.innerHTML=M(e,v(e))),C(n,t,m(e))&&(t.innerHTML=r)})),A(e,s),e.execCommand("mceInsertContent",!1,s.innerHTML),e.addVisual()};var I=tinymce.util.Tools.resolve("tinymce.Env");const N=(e,t)=>{const a=(e,t)=>((e,t,a)=>{for(let n=0,r=e.length;n<r;n++){const r=e[n];if(t(r,n))return T.some(r);if(a(r,n))break}return T.none()})(e,(e=>e.text===t),l),n=t=>{e.windowManager.alert("Could not load the specified template.",(()=>t.focus("template")))},r=e=>e.value.url.fold((()=>Promise.resolve(e.value.content.getOr(""))),(e=>fetch(e).then((e=>e.ok?e.text():Promise.reject())))),s=(e,t)=>(s,l)=>{if("template"===l.name){const l=s.getData().template;a(e,l).each((e=>{s.block("Loading..."),r(e).then((a=>{t(s,e,a)})).catch((()=>{t(s,e,""),s.setEnabled("save",!1),n(s)}))}))}},c=t=>s=>{const l=s.getData();a(t,l.template).each((t=>{r(t).then((t=>{e.execCommand("mceInsertTemplate",!1,t),s.close()})).catch((()=>{s.setEnabled("save",!1),n(s)}))}))};(()=>{if(!t||0===t.length){const t=e.translate("No templates defined.");return e.notificationManager.open({text:t,type:"info"}),T.none()}return T.from(o.map(t,((e,t)=>{const a=e=>void 0!==e.url;return{selected:0===t,text:e.title,value:{url:a(e)?T.from(e.url):T.none(),content:a(e)?T.none():T.from(e.content),description:e.description}}})))})().each((t=>{const a=(e=>((e,t)=>{const a=e.length,n=new Array(a);for(let t=0;t<a;t++){const a=e[t];n[t]={text:(r=a).text,value:r.text}}var r;return n})(e))(t),l=(e,a)=>({title:"Insert Template",size:"large",body:{type:"panel",items:e},initialData:a,buttons:[{type:"cancel",name:"cancel",text:"Cancel"},{type:"submit",name:"save",text:"Save",primary:!0}],onSubmit:c(t),onChange:s(t,i)}),i=(t,n,r)=>{const s=((e,t)=>{var a;if(-1===t.indexOf("<html>")){let n="";const r=null!==(a=f(e))&&void 0!==a?a:"",s=y(e)?' crossorigin="anonymous"':"";o.each(e.contentCSS,(t=>{n+='<link type="text/css" rel="stylesheet" href="'+e.documentBaseURI.toAbsolute(t)+'"'+s+">"})),r&&(n+='<style type="text/css">'+r+"</style>");const l=_(e),c=e.dom.encode,i='<script>document.addEventListener && document.addEventListener("click", function(e) {for (var elm = e.target; elm; elm = elm.parentNode) {if (elm.nodeName === "A" && !('+(I.os.isMacOS()||I.os.isiOS()?"e.metaKey":"e.ctrlKey && !e.altKey")+")) {e.preventDefault();}}}, false);<\/script> ",u=e.getBody().dir,m=u?' dir="'+c(u)+'"':"";t='<!DOCTYPE html><html><head><base href="'+c(e.documentBaseURI.getURI())+'">'+n+i+'</head><body class="'+c(l)+'"'+m+">"+t+"</body></html>"}return O(t,p(e))})(e,r),c=[{type:"selectbox",name:"template",label:"Templates",items:a},{type:"htmlpanel",html:`<p aria-live="polite">${w(n.value.description)}</p>`},{label:"Preview",type:"iframe",name:"preview",sandboxed:!1,transparent:!1}],i={template:n.text,preview:s};t.unblock(),t.redial(l(c,i)),t.focus("template")},u=e.windowManager.open(l([],{template:"",preview:""}));u.block("Loading..."),r(t[0]).then((e=>{i(u,t[0],e)})).catch((()=>{i(u,t[0],""),u.setEnabled("save",!1),n(u)}))}))};e.add("template",(e=>{(e=>{const t=e.options.register;t("template_cdate_classes",{processor:"string",default:"cdate"}),t("template_mdate_classes",{processor:"string",default:"mdate"}),t("template_selected_content_classes",{processor:"string",default:"selcontent"}),t("template_preview_replace_values",{processor:"object"}),t("template_replace_values",{processor:"object"}),t("templates",{processor:e=>a(e)||((e,t)=>{if(r(e)){for(let a=0,n=e.length;a<n;++a)if(!t(e[a]))return!1;return!0}return!1})(e,n)||s(e),default:[]}),t("template_cdate_format",{processor:"string",default:e.translate("%Y-%m-%d")}),t("template_mdate_format",{processor:"string",default:e.translate("%Y-%m-%d")})})(e),(e=>{const t=()=>e.execCommand("mceTemplate");e.ui.registry.addButton("template",{icon:"template",tooltip:"Insert template",onAction:t}),e.ui.registry.addMenuItem("template",{icon:"template",text:"Insert template...",onAction:t})})(e),(e=>{e.addCommand("mceInsertTemplate",function(e,...t){return(...a)=>{const n=t.concat(a);return e.apply(null,n)}}(D,e)),e.addCommand("mceTemplate",((e,t)=>()=>{const n=h(e);s(n)?n(t):a(n)?fetch(n).then((e=>{e.ok&&e.json().then(t)})):t(n)})(e,(e=>t=>{N(e,t)})(e)))})(e),(e=>{e.on("PreProcess",(t=>{const a=e.dom,n=v(e);o.each(a.select("div",t.node),(t=>{a.hasClass(t,"mceTmpl")&&(o.each(a.select("*",t),(t=>{C(a,t,u(e))&&(t.innerHTML=M(e,n))})),A(e,t))}))}))})(e)}))}();
