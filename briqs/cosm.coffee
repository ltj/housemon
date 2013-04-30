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
feeds = {}
datastreams = {}
#feed = new cosm.Feed(cosm, {id: 12345})
#stream = new cosm.Datastream(client, feed, {id: 1})

setup = ->
  feeds = cosmmap.feeds
  datastreams = cosmmap.datastreams
  for feed in feeds
    feed.feed = new cosm.Feed(cosm, {id: feed.id})
  for stream in datastreams
    for point in stream
      point.stream = new cosm.Datastream(client, cosmmap[point.feed].cosmfeed, {id: point.id})

sendData = (obj, oldObj) ->
  if obj and cosmmap.datastreams[obj.origin]?
    console.log 'cosm ' + obj.origin + ' ' + obj.name
    console.log feeds
    console.log datastreams
    feed = new cosm.Feed(cosm, {id: 12345})
    datastreams[obj.origin][obj.name]?.stream.addPoint obj.value

exports.factory = class
  constructor: ->
    setup()
    state.on 'set.status', sendData
  destroy: ->
    state.off 'set.status', sendData
