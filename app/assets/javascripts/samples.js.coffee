# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# On document ready
$ ->
  $(".nav-li").removeClass("active")
  $("#nav-samples").addClass("active")
  $('.btn-file :file').on 'fileselect', (event, label)->
    input = $(this).parents('.input-group').find(':text')
    input.val(label)
    true
  $('.btn-file :file').on 'change', ->
    input = $(this)
    label = input.val().replace(/\\/g, '/').replace(/.*\//, '')
    input.trigger('fileselect', label)
    true
  true

