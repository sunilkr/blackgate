# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/#

# On document ready
$ ->
  $(".nav-li").removeClass("active")
  $("#nav-incidents").addClass("active")
  $("#incident_reportedOn").datepicker({
    endDate: "todaye",
    format: "yyyy-mm-dd",
    autoclose: true,
    todayHighlight: true}
  )

