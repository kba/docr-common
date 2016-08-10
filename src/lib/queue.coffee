Kue = require 'kue'
Config = require './config'

log = require('easylog')(module)

module.exports = ->
	Jobs = Kue.createQueue(redis: options: Config.redis)
	Jobs.watchStuckJobs(1000 * 10)
	Jobs.on 'ready', ->
		log.info "Job queue is ready"
	Jobs.on 'error', (err) ->
		log.error("There was an error with the queue", err)
