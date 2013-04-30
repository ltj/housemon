exports.info =
  name: 'cosm'
  description: 'Send data to Cosm'
  connections:
    feeds:
      'status': 'collection'

# TODO: Add mapping between cosm feeds/datastreams and NodeMap

state = require '../server/state'
cosmmap = require './cosmMap-local'
cosm = require 'cosm'
client = new cosm.Cosm(cosmmap.apikey)
#feed = new cosm.Feed(cosm, {id: 12345})
#stream = new cosm.Datastream(client, feed, {id: 1})

setup = ->
  for feed in cosmmap.feeds
    feed.cosmfeed = new cosm.Feed(cosm, {id: feed.id})
  for stream in cosmmap.datastreams
    for point in stream
      point.stream = new cosm.Datastream(client, cosmmap[point.feed].cosmfeed, {id: point.id})

sendData = (obj, oldObj) ->
  if obj
    cosmmap.datastream[obj.origin][obj.name]?.stream.addPoint obj.value

exports.factory = class
  constructor: ->
    state.on 'set.status', sendData
  destroy: ->
    state.off 'set.status', sendData
