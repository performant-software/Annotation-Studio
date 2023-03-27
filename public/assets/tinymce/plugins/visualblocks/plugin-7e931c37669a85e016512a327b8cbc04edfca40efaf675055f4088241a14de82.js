!function(){"use strict";function t(t,o){return function(n){function e(t){return n.setActive(t.state)}return n.setActive(o.get()),t.on("VisualBlocks",e),function(){return t.off("VisualBlocks",e)}}}var o=function(t){function n(){return e}var e=t;return{get:n,set:function(t){e=t},clone:function(){return o(n())}}},n=tinymce.util.Tools.resolve("tinymce.PluginManager"),e=function(t,o){t.fire("VisualBlocks",{state:o})},i=function(t,o,n){t.dom.toggleClass(t.getBody(),"mce-visualblocks"),n.set(!n.get()),e(t,n.get())},u=function(t,o,n){t.addCommand("mceVisualBlocks",(function(){i(t,o,n)}))},c=function(t){return t.getParam("visualblocks_default_state",!1,"boolean")},s=function(t,o,n){t.on("PreviewFormats AfterPreviewFormats",(function(o){n.get()&&t.dom.toggleClass(t.getBody(),"mce-visualblocks","afterpreviewformats"===o.type)})),t.on("init",(function(){c(t)&&i(t,o,n)})),t.on("remove",(function(){t.dom.removeClass(t.getBody(),"mce-visualblocks")}))},l=function(o,n){o.ui.registry.addToggleButton("visualblocks",{icon:"visualblocks",tooltip:"Show blocks",onAction:function(){return o.execCommand("mceVisualBlocks")},onSetup:t(o,n)}),o.ui.registry.addToggleMenuItem("visualblocks",{text:"Show blocks",onAction:function(){return o.execCommand("mceVisualBlocks")},onSetup:t(o,n)})};n.add("visualblocks",(function(t,n){var e=o(!1);u(t,n,e),l(t,e),s(t,n,e)}))}();