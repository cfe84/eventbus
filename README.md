# Usage

```coffeescript
Bus = require "choreobus"
bus = new Bus
  debug: true           # Optional
  logger: console.log   #Optional

subscriptionId = bus.subscribe "event name", (event) -> console.log event.parameter
bus.publish "event name", "Hurray!"
bus.unsubscribe "event name", subscriptionId

```

Publish function also supports a correlationId parameter so you can trace what your event path is.

```coffeescript

bus.subscribe "event 1", (event) ->
    console.log event.correlationId
    bus.publish "event 2", "Hurray!", event.correlationId

bus.subscribe "event 2", (event) ->
    console.log event.correlationId
```

Will log

```
1
1
```
