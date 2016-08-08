Fs    = require 'fs'
Path  = require 'path'
Merge = require 'merge'
Uniq  = require 'uniq'
AppRoot = require 'app-root-path'
{TRAF}  = require 'traf'
Validator = require './validator'

log = require('easylog')(module)

C = null
unless C
	configFiles = Uniq [AppRoot, process.cwd(), '/etc'].map (base) -> "#{base}/docr-config.yml"
	for configFile in configFiles
		try
			config = TRAF.parseFileSync configFile
		catch e
			log.warn "Config file not found: #{configFile}"
			continue
		log.info "Config file found: #{configFile}"
		try
			Validator.validate['config'](config)
			log.info "Config file is valid: #{configFile}"
		catch e
			log.error "Config file is invalid: #{configFile}", e.errors
			throw e
		C = Merge C, config
		log.info "Loaded config file #{configFile}"

	if 'DOCR_CNC_PORT'    of process.env then C.cnc.port    = process.env.DOCR_CNC_PORT
	if 'DOCR_WORKER_PORT' of process.env then C.worker.port = process.env.DOCR_WORKER_PORT
	if 'DOCR_BLOB_URL'    of process.env then C.blob.url    = process.env.DOCR_BLOB_URL
	if 'DOCR_BLOB_PORT'   of process.env then C.blob.port   = process.env.DOCR_BLOB_PORT
	if 'REDIS_PORT'       of process.env then C.redis.port  = process.env.REDIS_PORT
	if 'REDIS_HOST'       of process.env then C.redis.host  = process.env.REDIS_HOST
	if 'REDIS_AUTH'       of process.env then C.redis.auth  = process.env.REDIS_AUTH

module.exports = C
