# -- Simple Cosm briq --
#
# Author: Lars Toft Jacosen
# version: 2013050101
#
# USAGE:
# Depends on cosm module. Install using 'npm install cosm'
# Listens for status updates so status briq must be installed.
# Cosm settings (API key, feeds and datastreams) must be configured
# separately in briqs/cosmMap-local.coffee.
#
# cosmMap-local must export 'apikey', 'feeds' and 'datastreams' like
# the following example:
#
# exports.apikey = 'your-api-key-here'
#
# exports.feeds =
#   123456: title: 'Test'       # replace 123456 with correct feed id
#   654321: title: 'some other feed'
#
# exports.datastreams =
#   'RF12:212:6':               # must match an origin
#     't1':                     # must match driver description name
#       feedid: 123456          # feed
#       streamid: 'temperature' # datastream
#     'p1':
#       feedid: 123456
#       streamid: 'pressure'
#   'RF12:212:11':
#     'v':
#       feedid: 654321
#       streamid: 'voltage'
#
exports.info =
  name: 'cosm'
  description: 'Send data to Cosm'
  connections:
    feeds:
      'status': 'collection'

state = require '../server/state'
cosmmap = require './cosmMap-local'
cosm = require 'cosm'
client = new cosm.Cosm(cosmmap.apikey, {server: 'https://api.xively.com'})
feeds = {}
streams = {}

setup = ->
  # build feed and datastream objects
  for id, title of cosmmap.feeds
    feeds[id] ?= new cosm.Feed(cosm, {id: id})
  for origin, names of cosmmap.datastreams
    for name, ids of names
      streams[origin+name] ?= new cosm.Datastream(client, feeds[ids.feedid], {id: ids.streamid})

sendData = (obj, oldObj) ->
  # send datapoint if origin/name has a stream
  if obj and streams[obj.origin+obj.name]?
    try
      streams[obj.origin+obj.name].addPoint obj.value
    catch e
      console.error e
    
    

exports.factory = class
  constructor: ->
    setup()
    state.on 'set.status', sendData
  destroy: ->
    state.off 'set.status', sendData
