!function(){"use strict";function t(o){return function(e){for(var t=0;t<e.length;t++)(n=e[t]).attr("href")||!n.attr("id")&&!n.attr("name")||n.firstChild||e[t].attr("contenteditable",o);var n}}var e=tinymce.util.Tools.resolve("tinymce.PluginManager"),a=function(e){return/^[A-Za-z][A-Za-z0-9\-:._]*$/.test(e)},n=function(e){var t=e.selection.getNode();return"A"===t.tagName&&""===e.dom.getAttrib(t,"href")?t.getAttribute("id")||t.getAttribute("name"):""},r=function(e,t){var n=e.selection.getNode();"A"===n.tagName&&""===e.dom.getAttrib(n,"href")?(n.removeAttribute("name"),n.id=t,e.undoManager.add()):(e.focus(),e.selection.collapse(!0),e.execCommand("mceInsertContent",!1,e.dom.createHTML("a",{id:t})))},o=function(o){var e=n(o);o.windowManager.open({title:"Anchor",size:"normal",body:{type:"panel",items:[{name:"id",type:"input",label:"ID",placeholder:"example"}]},buttons:[{type:"cancel",name:"cancel",text:"Cancel"},{type:"submit",name:"save",text:"Save",primary:!0}],initialData:{id:e},onSubmit:function(e){var t,n;t=o,n=e.getData().id,!(a(n)?(r(t,n),0):(t.windowManager.alert("Id should start with a letter, followed only by letters, numbers, dashes, dots, colons or underscores."),1))&&e.close()}})},i=function(e){e.addCommand("mceAnchor",function(){o(e)})},c=function(e){e.on("PreInit",function(){e.parser.addNodeFilter("a",t("false")),e.serializer.addNodeFilter("a",t(null))})},d=function(t){t.ui.registry.addToggleButton("anchor",{icon:"bookmark",tooltip:"Anchor",onAction:function(){return t.execCommand("mceAnchor")},onSetup:function(e){return t.selection.selectorChangedWithUnbind("a:not([href])",e.setActive).unbind}}),t.ui.registry.addMenuItem("anchor",{icon:"bookmark",text:"Anchor...",onAction:function(){return t.execCommand("mceAnchor")}})};!function u(){e.add("anchor",function(e){c(e),i(e),d(e)})}()}();