class EventBus
	constructor : (options) ->
    @debug = options?.debug
    @log = options?.log ? console.log
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
		@log "EventBus: (#{eventName}): new subscription - #{stack} (#{id})" if @debug
		id

	publish: (eventName, parameter) =>
		id = ++@id
		@log "EventBus: event #{id} (#{eventName}): published event #{eventName} from #{@getStack()}" if @debug
		return @log "EventBus: event #{id} (#{eventName}): no subscription" if @debug and !@bus[eventName]
		for regid, callback of @bus[eventName]
			@log "EventBus: event #{id} (#{eventName}): calling #{callback.stack} (#{regid})" if @debug
			try
				callback.callback
					parameter: parameter
					id: id
					name: eventName
					registrationid: regid
			catch exception
				@log "EventBus: error while pushing event #{eventName} to #{callback.stack}: #{exception}"

	unsubscribe: (eventName, id) =>
		return @log "EventBus: (#{eventName}): has no subscription" if @debug and !@bus[eventName]
		return @log "EventBus: (#{eventName}): does not have a subscription with id #{id}" if @debug and !@bus[eventName]
		reg = @bus[eventName][id]
		delete @bus[eventName][id]
		@log "EventBus: (#{eventName}): subscription #{id} deleted (#{reg.stack})" if @debug

module.exports = EventBus