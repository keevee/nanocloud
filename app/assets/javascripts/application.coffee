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

getURLParameter = (name) ->
  component = (new RegExp("[?|&]#{name}=([^&;]+?)(&|##|;|$)").exec(location.search) || [null,""] )[1].replace(/\+/g, '%20')
  decodeURIComponent(component) || null

fbroot = undefined
$ ->
  if jobId = getURLParameter('job_id')
    fbroot = new Firebase("https://nanocloud.firebaseio.com/logs/"+jobId)
    fbroot.on "child_added", (childSnapshot, prevChildName) ->

      msg = childSnapshot.val().message
      $("#output").html(childSnapshot.val().severity + ":" + (if typeof(msg)=="object" then msg.join('\n') else msg ) + "\n\n" + $("#output").html())

