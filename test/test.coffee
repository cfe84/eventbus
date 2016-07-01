log = (string) -> console.log string

assert = (test) ->
	count = 0
	assertionCount = () =>
		++count
	that: (actual) ->
		isTrue: -> assert(test).that(actual).is(true)
		isFalse: -> assert(test).that(actual).is(false)
		isNull: -> assert(test).that(actual).is(null)
		isDefined: -> assert(test).that(actual).isNot(undefined)
		isUndefined: -> assert(test).that(actual).is(undefined)
		isNotNull: -> assert(test).that(actual).isnt(null)
		isNot: (expected) -> assert(test).that(actual).isnt(expected)
		is: (expected) -> assert(test).that(actual).compares ((actual) -> actual is expected), "expected: #{expected} - actual: #{actual}"
		isnt: (expected) -> 
			assert(test).that(actual).compares ((actual) -> actual isnt expected), "not expected: #{expected} - actual: #{actual}"
		compares: (func, explain) ->
			(if func(actual) then assert(test).success else assert(test).failure) explain
	failure: (explain) -> 
		log "#{test} (assertion #{assertionCount()}): Failure - #{explain}"
		throw explain
	success: (explain) -> log "#{test} (assertion #{assertionCount()}): Success"

module.exports = assert