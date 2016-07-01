class EventBus
	constructor : ({@debug} = options) ->
		@bus = []
		@registrationId = 0
		@id = 0
		@getStack = () ->
			stack = new Error().stack.split("\n")[3]
			stack = stack.replace /^(.*)\/([^\/]+$)/i, "$2"

	subscribe: (eventName, callback) =>
		@bus[eventName] = [] unless @bus[eventName]
		id = "reg-#{@registrationId++}"
		stack = if @debug then @getStack() else "Activate debug to access stacktrace"
		@bus[eventName][id] = 
			callback: callback
			stack: stack
			id: id
		console.log "EventBus: (#{eventName}): new subscription - #{stack} (#{id})" if @debug
		id

	trigger: (eventName, parameter) =>
		id = ++@id
		console.log "EventBus: event #{id} (#{eventName}): triggered event #{eventName} from #{@getStack()}" if @debug
		return console.log "EventBus: event #{id} (#{eventName}): no subscription" if @debug and !@bus[eventName]
		for regid, callback of @bus[eventName]
			console.log "EventBus: event #{id} (#{eventName}): calling #{callback.stack} (#{regid})" if @debug
			callback.callback
				parameter: parameter
				id: id
				name: eventName
				registrationid: regid

	unsubscribe: (eventName, id) =>
		return console.log "EventBus: (#{eventName}): has no subscription" if @debug and !@bus[eventName]
		return console.log "EventBus: (#{eventName}): does not have a subscription with id #{id}" if @debug and !@bus[eventName]
		reg = @bus[eventName][id]
		delete @bus[eventName][id]
		console.log "EventBus: (#{eventName}): subscription #{id} deleted (#{reg.stack})" if @debug

exports = this
exports.EventBus = EventBus