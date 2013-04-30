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
streams = {}
#feed = new cosm.Feed(cosm, {id: 12345})
#stream = new cosm.Datastream(client, feed, {id: 1})

setup = ->
  for id, title of cosmmap.feeds
    feeds[id] ?= new cosm.Feed(cosm, {id: id})
  for origin, names of cosmmap.datastreams
    for name, ids of names
      s = {}
      s[name] = new cosm.Datastream(client, feeds[ids.feedid], {id: ids.streamid})
      streams[origin] ?= s

sendData = (obj, oldObj) ->
  if obj and cosmmap.datastreams[obj.origin]?
    console.log 'cosm ' + obj.origin + ' ' + obj.name
    console.log feeds
    console.log streams
    feed = new cosm.Feed(cosm, {id: 12345})
    streams[obj.origin][obj.name]?.addPoint obj.value

exports.factory = class
  constructor: ->
    setup()
    state.on 'set.status', sendData
  destroy: ->
    state.off 'set.status', sendData
