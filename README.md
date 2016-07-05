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