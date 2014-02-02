#
# PUSHERANGULAR - Get ready for realtime chats in angularjs
#
# Author: Alessio Santo
# Version: 0.6
# 
# Docs for pusher: http://pusher.com/docs
#

pushrangular = angular.module('pusherAngular', []).provider('Pusher', [->

	@version = "1.0"
	@name 	 = "PushrAngular"

	logger = "PUSHER -> "

	# CHECK IF THE PUSHER OBJECT HAS BEEN LOADED
	if not window.hasOwnProperty("Pusher")
		console.error logger,"INSTALL PUSHER FIRST"


	PusherClass = window.Pusher

	settings = {
		app_key: null
		api_url: null
		options: {}
	}

	@development_mode = false

	# SET THE APP KEY
	@setAppKey = (key)->
		settings.app_key = key

	# SET THE SERVER API URL
	@setServerApiUrl = (url)->
		settings.api_url = url

	# FACTORY: Pusher
	@$get = ['$http', ($http)->

		# CHECK IF DEVELOPMENT MODE
		if @development_mode
			# ENABLE CONSOLE LOGGING
			PusherClass.log = (message)->
				if window.console && window.console.log
					console.log logger,message

		# CHECK IF THE SERVER API URL HAS BEEN SET
		if settings.api_url is null
			console.error logger,"FUNCTION TRIGGER WILL NOT BE AVAILABLE: PLEASE INSERT THE API URL"
			console.log logger,"READ ONLY MODE"



		# THE PUSHER OBJECT
		@pusher 	= new PusherClass settings.app_key,settings.options

		# SUBSCRIBE TO A CHANNEL
		@subscribe 	= (name)->
			@pusher.subscribe(name)

		# THE CONNECTION OBJECT
		@getConnection 	= ->
			@pusher.connection

		# SEND SOMETHING THROUGH A CHANNEL
		@trigger 	= (channel_name, event_name, data)->

			# CHECK IF THE API URL HAS BEEN SET
			if settings.api_url is null
				console.error logger,"NO SERVER API URL HAS BEEN SET"
				return false

			# GET THE CHANNEL
			channel = @pusher.channel(channel_name)

			# IS THERE A CHANNEL WITH THAT NAME?
			if channel?
				$http.post(settings.api_url, {
					event:
						name 	: event_name
						data	: data
						channel : channel.name
				}).success((response)->
					# alert response
				)
				console.log logger,"CHANNEL => %o",channel
			else
				console.error logger,"NO CHANNEL AVAILABLE => %s",channel_name


		@
	]

	@
])