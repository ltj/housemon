exports.info =
  name: 'cosm'
  description: 'Send data to Cosm'
  connections:
    feeds:
      'status': 'collection'

state = require '../server/state'
cosm = require 'cosm'
client = new cosm.Cosm('insert API key here')
feed = new cosm.Feed(cosm, {id: 12345})
stream = new cosm.Datastream(client, feed, {id: 1})

sendData = (obj, oldObj) ->
  if obj
    console.log 'cosm'
    console.log obj

exports.factory = class
  constructor: ->
    state.on 'set.status', sendData
  destroy: ->
    state.off 'set.status', sendData