Test = require "./test"
EventBus = require "../src/eventbus"

EVENTNAME="blsfkdslfs"

logs = []
log = (message) => logs.push message

noSubscriber = () ->
  assert = Test "No subscriber"
  bus = new EventBus
    debug: true
    log: log

  obj = "1243"
  bus.publish EVENTNAME, obj
  (assert.that logs.length).compares ((length) -> length > 0), "No logs"
noSubscriber()

oneSubscriber = () ->
  assert = Test "One subscriber"
  bus = new EventBus
    debug: true
    log: log

  res = undefined
  obj = "1243"
  bus.subscribe EVENTNAME, (param) -> res = param
  bus.publish EVENTNAME, obj
  (assert.that res.name).is EVENTNAME
  (assert.that res.parameter).is obj
  (assert.that logs.length).compares ((length) -> length > 0), "No logs"
oneSubscriber()

severalSubscribers = () ->
  assert = Test "Several subscribers"
  bus = new EventBus
    debug: true
    log: log

  res1 = undefined
  res2 = undefined
  obj1 =
    toto: "stuff"
    pouet: "lalala"
  bus.subscribe EVENTNAME, (param) ->
    (assert.that res1).isUndefined()
    (assert.that res2).isUndefined()
    res1 = param
  bus.subscribe EVENTNAME, (param) ->
    (assert.that res2).isUndefined()
    (assert.that res1).isNotNull()
    res2 = param
  bus.publish EVENTNAME, obj1
  (assert.that res1.name).is EVENTNAME
  (assert.that res1.parameter.toto).is obj1.toto
  (assert.that res1.parameter.pouet).is obj1.pouet
  (assert.that res2.parameter.toto).is obj1.toto
  (assert.that res2.parameter.pouet).is obj1.pouet
severalSubscribers()

sendingSeveralMessages = () ->
  assert = Test "Several messages"
  bus = new EventBus
    debug: true
    log: log

  res1 = undefined
  res2 = undefined
  obj1 =
    toto: "stuff"
    pouet: "lalala"
  obj2 =
    titi: "lalali"
  bus.subscribe EVENTNAME, (param) ->
    if res1 is undefined
      res1 = param
    else if res2 is undefined
      res2 = param
    else
      assert.failure "Received 3 messages, while sending only 2"
  bus.publish EVENTNAME, obj1
  bus.publish EVENTNAME, obj2
  (assert.that res1.name).is EVENTNAME
  (assert.that res1.parameter.toto).is obj1.toto
  (assert.that res1.parameter.pouet).is obj1.pouet
  (assert.that res2.parameter.titi).is obj2.titi
sendingSeveralMessages()


severalEvents = () ->
  assert = Test "Several event names"
  bus = new EventBus
    debug: true
    log: log

  res1 = undefined
  res2 = undefined
  obj1 =
    toto: "stuff"
    pouet: "lalala"
  obj2 =
    titi: "lalali"
  bus.subscribe EVENTNAME, (param) ->
    res1 = param
  bus.subscribe EVENTNAME + "2eee", (param) ->
    res2 = param

  bus.publish EVENTNAME, obj1
  bus.publish EVENTNAME + "2eee", obj2
  (assert.that res1.name).is EVENTNAME
  (assert.that res1.parameter.toto).is obj1.toto
  (assert.that res1.parameter.pouet).is obj1.pouet
  (assert.that res2.name).is EVENTNAME + "2eee"
  (assert.that res2.parameter.titi).is obj2.titi
severalEvents()

unsubscribing = () ->
  assert = Test "Unsubscribing"
  bus = new EventBus
    debug: true
    log: log
  res1 = undefined
  obj =
    toto: "stuff"
    pouet: "lalala"
  registration = bus.subscribe EVENTNAME, (param) ->
    if res1 is undefined
      res1 = param
    else
      assert.failure "Should have received only one message"
  bus.publish EVENTNAME, obj
  bus.unsubscribe EVENTNAME, registration
  bus.publish EVENTNAME, obj
  (assert.that res1.name).is EVENTNAME
  (assert.that res1.parameter.toto).is obj.toto
  (assert.that res1.parameter.pouet).is obj.pouet
unsubscribing()

exception = () ->
  slogs = []
  slog = (msg) -> slogs.push msg
  assert = Test "Exception is logged and does not stop processing"
  bus = new EventBus
    debug: false
    log: slog
  res1 = null
  res2 = null
  EXCEPTION = "dfjhwoeurhwnv"
  MSG = " dfsf s qwr efrs "
  bus.subscribe EVENTNAME, (msg) -> res1 = msg
  bus.subscribe EVENTNAME, (msg) -> throw EXCEPTION
  bus.subscribe EVENTNAME, (msg) -> res2 = msg
  bus.publish EVENTNAME, MSG
  (assert.that res1.name).is EVENTNAME
  (assert.that res1.parameter).is MSG
  (assert.that res2.parameter).is MSG
  (assert.that slogs.length).is 1
  (assert.that slogs[0]).compares ((msg) -> msg.indexOf(EXCEPTION) >= 0), "Exception is not logged correctly"

exception()