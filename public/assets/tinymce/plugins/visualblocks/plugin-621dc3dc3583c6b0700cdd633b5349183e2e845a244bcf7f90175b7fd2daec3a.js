!function(){"use strict";function r(t,o,e){var n,i;t.dom.toggleClass(t.getBody(),"mce-visualblocks"),e.set(!e.get()),n=t,i=e.get(),n.fire("VisualBlocks",{state:i})}function f(e,n){return function(o){function t(t){return o.setActive(t.state)}return o.setActive(n.get()),e.on("VisualBlocks",t),function(){return e.off("VisualBlocks",t)}}}tinymce.util.Tools.resolve("tinymce.PluginManager").add("visualblocks",function(t){function o(){return s.execCommand("mceVisualBlocks")}var e,n,i,s,c,u,l,a=(e=!1,{get:function(){return e},set:function(t){e=t}});i=a,(n=t).addCommand("mceVisualBlocks",function(){r(n,0,i)}),(s=t).ui.registry.addToggleButton("visualblocks",{icon:"visualblocks",tooltip:"Show blocks",onAction:o,onSetup:f(s,c=a)}),s.ui.registry.addToggleMenuItem("visualblocks",{text:"Show blocks",icon:"visualblocks",onAction:o,onSetup:f(s,c)}),l=a,(u=t).on("PreviewFormats AfterPreviewFormats",function(t){l.get()&&u.dom.toggleClass(u.getBody(),"mce-visualblocks","afterpreviewformats"===t.type)}),u.on("init",function(){u.getParam("visualblocks_default_state",!1,"boolean")&&r(u,0,l)})})}();