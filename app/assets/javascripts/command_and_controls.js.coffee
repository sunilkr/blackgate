# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#

$ ->
  $(".nav-li").removeClass("active")
  $("#nav-cnc").addClass("active")
  $("input[data-behaviour='datepicker']").datepicker(
    endDate:    "today"
    format:     "yyyy-mm-dd"
    autoclose:  true
  )
  true
