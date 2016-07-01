log = (string) -> console.log string

test = (name) =>
	count = 0
	assert = () =>
		that: (actual) =>
			isTrue: => assert().that(actual).is(true)
			isFalse: => assert().that(actual).is(false)
			isNull: => assert().that(actual).is(null)
			isDefined: => assert().that(actual).isNot(undefined)
			isUndefined: => assert().that(actual).is(undefined)
			isNotNull: => assert().that(actual).isnt(null)
			isNot: (expected) => assert().that(actual).isnt(expected)
			is: (expected) => assert().that(actual).compares ((actual) -> actual is expected), "expected: #{expected} - actual: #{actual}"
			isnt: (expected) =>
				assert().that(actual).compares ((actual) -> actual isnt expected), "not expected: #{expected} - actual: #{actual}"
			compares: (func, explain) =>
				(if func(actual) then assert().success else assert().failure) explain
		failure: (explain) =>
			log "#{name} (assertion #{++count}): Failure - #{explain}"
			throw explain
		success: (explain) => log "#{name} (assertion #{++count}): Success"
	assert()

module.exports = test