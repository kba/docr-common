Test = require 'tape'
log = require('easylog')(module)

Test 'config loading', (t) ->
	conf = require '../lib/config'
	log.debug conf
	t.equals conf.jobserver.port, 3001, "Loaded from YAML"
	t.end()

Test 'queue', (t) ->
	q = require '../lib/queue'
	t.equals q.name, 'kue', 'queue name'
	log.debug "Shutting down"
	q.shutdown 0, (err) ->
		log.debug "Shut down"
		t.end()
		process.exit()
