# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
# Loads all Bootstrap javascripts
#= require jquery
#= require jquery_ujs
#= require bootstrap
#= require_tree .
#= require firebase
#

getURLParameter = (name) ->
  component = (new RegExp("[?|&]#{name}=([^&;]+?)(&|##|;|$)").exec(location.search) || [null,""] )[1].replace(/\+/g, '%20')
  decodeURIComponent(component) || null

fbroot = undefined
$ ->
  APP_NAME = $('body').data('appname')
  if jobId = getURLParameter('job_id')
    console.log "FB Base: https://nanocloud.firebaseio.com/#{APP_NAME}/logs"
    fbroot = new Firebase("https://nanocloud.firebaseio.com/#{APP_NAME}/logs/"+jobId)
    fbroot.on "child_added", (childSnapshot, prevChildName) ->

      message = childSnapshot.val().message
      message = message.join('\n') if typeof(message) == 'object'

      level   = childSnapshot.val().severity

      out = $('#output')

      out.html(out.html()+"<span class='level-#{level}'>#{message}</span>\n")
      out.scrollTop out[0].scrollHeight
