// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .


$(document).ready(function(){
	
//  $("p").click(function(){
//    // $(this).hide();
//    
//    // REF css() http://stackoverflow.com/questions/12197828/how-to-set-style-display-of-an-html-element answered Aug 30 '12 at 13:22
//    // REF http://api.jquery.com/css/
//    $(this).css("background-color", "blue");
//  });
  
  $("#show_button").click(function(){
	  
	  $(this).attr("disabled", true);
	  
	  //REF http://www.tohoho-web.com/js/jquery/ajax.htm
	  $.ajax({
//		    url: "/genres/show_log",
		    url: "/admin/show_log",
		    type: "GET",
		    timeout: 10000
		}).done(function(data, status, xhr) {
			
		    $("#show_log").html(data);
		    
//		    $(this).prop("disabled", true);	//=> Not working
		    
//		    $(this).attr("disabled", true);	//=> Not working
		    
		    //REF http://stackoverflow.com/questions/3806685/jquery-add-disabled-attribute-to-input answered Sep 27 '10 at 18:32
//		    document.getElementById("show_log").disabled = true;	//=> Not working
		    
		    $("#hide_button").removeAttr("disabled");
		    
		    $(".log_navigation").show();
		    
		    
		}).fail(function(xhr, status, error) {
		    $("#show_log").append("xhr.status = " + xhr.status + "<br>");          // 例: 404
		    
		    $("#show_button").removeAttr("disabled");
		    
//		    $("#log").append("xhr.statusText = " + xhr.statusText + "<br>");  // 例: Not Found
//		    $("#log").append("status = " + status + "<br>");                  // 例: error
//		    $("#log").append("error = " + error + "<br>");                    // 例: Not Found
		});
	  
	  
	  
////	  alert("Show");
//	  
//
//    $("#logs").show();
//
//    // REF disabled http://stackoverflow.com/questions/5580616/jquery-change-button-text
//    $(this).attr("disabled", true);
//    
//    // REF disabled http://d.hatena.ne.jp/ogakky/20110711/1310349297
//    $("#hide_button").removeAttr("disabled");
////    $(".hide_button").removeAttr("disabled");
//    
//    
//    // $("#logs").css("visibility", "visible");
  });
  
//  $(".hide_button").click(function(){
  $("#hide_button").click(function(){

	  $("#show_log").html("LOG");
	  
	  $(this).attr("disabled", true);
	  
	  $("#show_button").removeAttr("disabled");
	  
	  $(".log_navigation").hide();
	  
//    // alert($(this).attr("value"));
//
//	// REF visibility http://www.htmq.com/style/visibility.shtml
//    // $("#logs").css("visibility", "hide");
//    $("#logs").hide();
//    
//    $(this).attr("disabled", true);
//    $("#show_button").removeAttr("disabled");
    
  });
  
  $("#item_refactor_table_word_lists").click(function(){

    // alert($(this).css("value"));
    // alert($(this).attr("value"));

    
  });
  
  // 
  
});