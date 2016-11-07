class EventBus
	constructor : (options = {}) ->
    { @debug = false, @rethrowExceptions = false, @log = (msg) -> console.log msg } = options
    @bus = []
    @registrationId = 0
    @id = 0
    @getStack = () ->
      stack = new Error().stack.split("\n")[4]
      stack = stack.replace /^(.*)\/([^\/]+$)/i, "$2"

	subscribe: (eventName, callback, description) =>
		@bus[eventName] = [] unless @bus[eventName]
		regid = "reg-#{@registrationId++}"
		stack = if @debug then @getStack() else "Activate debug to access stacktrace"
		@bus[eventName][regid] =
      callback: callback
      stack: stack
      id: regid
      description: description ? "calling #{callback.stack} (#{regid})"
		@log "EventBus: (#{eventName}): new subscription - #{stack} (#{regid})" if @debug
		regid

	publish: (eventName, parameter, correlationId = null) =>
		id = ++@id
		correlationId = correlationId ? id
		@log "EventBus: ##{correlationId} event #{id} (#{eventName}): published event #{eventName} from #{@getStack()}" if @debug
		return @log "EventBus: ##{correlationId} - event #{id} (#{eventName}): no subscription" if @debug and !@bus[eventName]
		for regid, callback of @bus[eventName]
			@log "EventBus: ##{correlationId} - event #{id} (#{eventName}): #{callback.description}" if @debug
			try
				callback.callback
					parameter: parameter
					id: id
					correlationId: correlationId
					name: eventName
					registrationid: regid
			catch exception
        @log "EventBus: ##{correlationId} - event #{id}: error while pushing event #{eventName} to #{callback.stack}: #{exception}"
        throw exception if @rethrowExceptions

	unsubscribe: (eventName, id) =>
		return @log "EventBus: (#{eventName}): has no subscription" if @debug and !@bus[eventName]
		return @log "EventBus: (#{eventName}): does not have a subscription with id #{id}" if @debug and !@bus[eventName]
		reg = @bus[eventName][id]
		delete @bus[eventName][id]
		@log "EventBus: (#{eventName}): subscription #{id} deleted (#{reg.stack})" if @debug

module.exports = EventBus