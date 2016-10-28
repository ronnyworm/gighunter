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

		$("#l_currentid").val(currentLocation);
		$("#l_currentname").val($("#name-" + currentLocation).html());
		$("#l_currentaddress").val($("#address-" + currentLocation).html());
		$("#l_currentwebsite").val($("#website-" + currentLocation).children().html());
		$("#l_currentfestival").prop("checked", $("#festival-" + currentLocation).html() == "ja");

		$("#l_currentcontact").val($("#contact-" + currentLocation).html());
    });

    $("[id^=contact-]").click(function(){
	    currentContact = $(this).attr('id').substring("contact-".length);

		$("#c_currentid").val(currentContact);
		$("#c_currentname").val($("#name-" + currentContact).html());
		$("#c_currentemail").val($("#email-" + currentContact).html());
		$("#c_currentphone").val($("#phone-" + currentContact).html());
		$("#c_currentinfo").val($("#info-" + currentContact).html());
    });

    $("[id^=status-]").click(function(){
	    currentStatus = $(this).attr('id').substring("status-".length);

		$(".currentid").val(currentStatus);
		$("#currenttext").val($("#text-" + currentStatus).html());
		$("#currentorder").val($("#order-" + currentStatus).html());
    });
});