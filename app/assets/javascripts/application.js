// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require_tree .

$(document).ready(function(){
    $("[id^=location-]").click(function(){
	    currentLocation = $(this).attr('id').substring("location-".length);

		$("#currentid").val(currentLocation);
		$("#currentname").val($("#name-" + currentLocation).html());
		$("#currentaddress").val($("#address-" + currentLocation).html());
		$("#currentwebsite").val($("#website-" + currentLocation).html());
		$("#currentfestival").prop("checked", $("#festival-" + currentLocation).html() == "ja");

		$("#currentcontact").val($("#contact-" + currentLocation).html());
    });

    $("[id^=contact-]").click(function(){
	    currentContact = $(this).attr('id').substring("contact-".length);

		$("#currentid").val(currentContact);
		$("#currentname").val($("#name-" + currentContact).html());
		$("#currentemail").val($("#email-" + currentContact).html());
		$("#currentphone").val($("#phone-" + currentContact).html());
		$("#currentinfo").val($("#info-" + currentContact).html());
    });

    $("[id^=status-]").click(function(){
	    currentStatus = $(this).attr('id').substring("status-".length);

		$(".currentid").val(currentStatus);
		$("#currenttext").val($("#text-" + currentStatus).html());
		$("#currentorder").val($("#order-" + currentStatus).html());
    });
});