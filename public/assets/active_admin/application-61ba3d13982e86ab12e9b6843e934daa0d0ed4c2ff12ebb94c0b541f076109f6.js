(function(){$(document).on("ready page:load",function(){var t;if($(document).on("focus",".datepicker:not(.hasDatepicker)",function(){var t,e;return t={dateFormat:"yy-mm-dd"},e=$(this).data("datepicker-options"),$(this).datepicker($.extend(t,e))}),$(".clear_filters_btn").click(function(){var i,a,r;return a=window.location.search.split("&"),r=/^(q\[|q%5B|q%5b|page|commit)/,window.location.search=function(){var t,e,n;for(n=[],t=0,e=a.length;t<e;t++)(i=a[t]).match(r)||n.push(i);return n}().join("&")}),$(".filter_form").submit(function(){return $(this).find(":input").filter(function(){return""===this.value}).prop("disabled",!0)}),$(".filter_form_field.select_and_search select").change(function(){return $(this).siblings("input").prop({name:"q["+this.value+"]"})}),$("#active_admin_content .tabs").tabs(),(t=$(".table_tools .batch_actions_selector")).length)return t.next().css({width:"calc(100% - 10px - "+t.outerWidth()+"px)","float":"right"})})}).call(this);