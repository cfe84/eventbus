class Choregraphy
	constructor: (@eventBus, @events) ->
		@regid = 0
		@eventname = ""

	start: ()=>
		subscribe = ([evt, tail...]) =>
			callback = (event) =>
				console.log "Choregraphy: Triggering for event #{event.name}, id##{event.id}"
				@eventBus.unsubscribe event.name, event.registrationid
				evt.callback(event)
				if tail isnt undefined and tail.length > 0
					subscribe tail	
				else
					console.log "Choregraphy: Reached the end of choregraphy, starting again"
					subscribe @events
			@regid = @eventBus.subscribe evt.event, callback
			@eventname = evt.event
		subscribe @events

	stop: ()=>
		@eventBus.unsubscribe @eventname, @regid

exports = this
exports.Choregraphy = Choregraphy