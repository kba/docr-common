Fs = require 'fs'
Ajv   = require 'ajv'
{TRAF}  = require 'traf'

module.exports = {}

module.exports.ajv = ajv = new Ajv(
	v5: false
	verbose: true
	jsonPointers: true
	allErrors: true
)

module.exports.schemas = schemas = {}
module.exports.compiled = compiled = {}
module.exports.validate = validate = {}

for schemaFile in Fs.readdirSync "#{__dirname}/../schema"
	name = schemaFile.replace /\..+$/, ''
	schemas[name] = TRAF.parseFileSync("#{__dirname}/../schema/#{schemaFile}")
	compiled[name] = ajv.compile(schemas[name])
	do (name) ->
		validate[name] = (data) ->
			unless compiled[name](data)
				err = new Error("Invalid against '#{name}' schema!")
				err.errors = compiled[name].errors
				throw err
