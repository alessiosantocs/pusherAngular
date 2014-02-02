# 
# Javascript example usage of pusherAngular
# 
anguchat = angular.module('anguchat', ['pusherAngular'])

# CONFIG YOUR MODULE
# What to do: 
# 	1. Do an angular module configuration on your final module
# 	2. Request PusherProvider, you will need to configure it
# 	3. Set the AppKey
# 	4. Set the environment
# 	5. Set the ServerApiUrl
# 	6. That's it for configuration

anguchat.config(['PusherProvider', (PusherProvider)->
	PusherProvider.setAppKey "<YOUR APP KEY>"
	PusherProvider.development_mode = false
	PusherProvider.setServerApiUrl "/api/pusher"
])


# CREATE YOUR CONTROLLER
# What to do: 
# 	1. Ask for Pusher injection
# 	2. Prepare the scope and the channel
# 	3. Prepare the send function
# 	4. Prepare the fetch function
# 	5. Start chatting ;)

anguchat.controller("ChatCtrl", ['Pusher', '$scope', (Pusher, $scope)->

	# THIS WILL CONTAIN OUR MESSAGES
	$scope.messages = []
	$scope.channel 	= "test_channel"

	# SUBSCRIBE TO A CHANNEL
	channel = Pusher.subscribe($scope.channel);

	# BINDING MESSAGES
	channel.bind("messages", fetch)

	$scope.send = (message)->
		Pusher.trigger($scope.channel, "messages", {
			value: message.body
			author: message.author
		})

	fetch = (data)->
		$scope.$apply(->
			$scope.messages.push data
		)

	true

])