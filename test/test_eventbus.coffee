Test = require "../test/test"
Eventbus = require "./eventbus"

EVENTNAME="blsfkdslfs"

subscribingToEventGetYouSubscribed = () ->
  assert = Test "Subscribing to an event gets you the events"
  bus = new EventBus
    debug: false
  res = undefined
  obj = "1243"
  bus.subscribe EVENTNAME, (param) -> res = param
  bus.publish EVENTNAME, obj
  (assert.that res).isnt undefined
  (assert.that res).isnt null
  (assert.that res.name).is EVENTNAME
  (assert.that res.parameter).is obj

subscribingToEventGetYouSubscribed()