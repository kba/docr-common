Test = require 'tape'
Fs = require 'fs'
log = require('easylog')(module)

Test 'config loading', (t) ->
	conf = require '../lib/config'
	log.debug conf
	t.equals conf.jobserver.port, 3001, "Loaded from YAML"
	t.end()

Test 'queue', (t) ->
	q = require('../lib/queue')()
	t.equals q.name, 'kue', 'queue name'
	log.debug "Shutting down ..."
	q.shutdown 1, (err) ->
		log.debug "... shut down"
		t.end()

Test 'blob-client', (t) ->
	Client = require '../lib/blob-client'
	# client.download 'https://avatars1.githubusercontent.com/u/273367?v=3&s=40', {abspath: '/tmp/test'}, (err) ->
		# console.log arguments
	testfile = "#{__dirname}/TEST.TXT"
	testfile2 = "#{__dirname}/TEST2.TXT"
	Fs.writeFile testfile, "foo bar", (err) ->
		Client.upload testfile, {contentType: 'text/plain'}, (err) ->
			Client.download 'urn:sha1:3773dea65156909838fa6c22825cafe090ff8030', {abspath: testfile2}, (err) ->
				contents1 = Fs.readFileSync testfile
				contents2 = Fs.readFileSync testfile2
				t.equals contents1.toString(), contents2.toString(), "Correctly loaded"
				t.end()
