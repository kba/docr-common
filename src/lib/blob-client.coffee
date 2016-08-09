Fs = require 'fs'
Path = require 'path'
Request = require 'request'

Config = require './config'
Utils = require './utils'

URL_RE = /^https?:\/\/.*/

module.exports = \
class BlobClient

	## download
	# Options:
	# * `abspath`: Absolute path to the file
	# * `cwd`: Directory to store the file in
	# * `basename`: Filename of the file w/o path
	@download: (url, opts, done) ->
		unless 'abspath' of opts
			unless 'cwd' of opts
				return done new Error("Must specify 'abspath' or 'cwd' and 'basename'")
			unless opts.cwd.indexOf('/') is 0
				return done new Error("'cwd' must be absolute.")
			if 'basename' of opts
				opts.abspath = "#{opts.cwd}/#{opts.basename}"
			else
				opts.abspath = "#{opts.cwd}/#{Utils.cleanURI(url)}"
		if Utils.isSHA1(url)
			url = "#{Config.blob.url}/#{url}"
		ws = Fs.createWriteStream(opts.abspath)
		Request(
			method: 'GET'
			url: url
			, (err, res, body) ->
				return done err if err
				return done()
		).pipe ws

	@upload: (abspath, opts, done) ->
		opts.contentType or= 'application/octet-stream'
		Request
			method: 'POST'
			url: Config.blob.url
			formData:
				file:
					value: Fs.createReadStream abspath
					options:
						filename: Path.basename(abspath)
						contentType: opts.contentType
		, (err, res, body) ->
			return done err if err
			console.log body
			return done()

