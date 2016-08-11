NodeUtil = require 'util'
RE =
	uriProtocol: /^(urn:sha1:|https?:\/\/)/
	unsafeChars: /[^a-zA-Z0-9_.-]/

module.exports = \
class Utils

	@RE: RE

	@isSHA1 : (str) -> str and str.match /^(urn:sha1:)?[a-f0-9]{40}/

	@cleanURI : (str) -> str.replace(RE.uriProtocol, '').replace(RE.unsafeChars, '')

	@isObject: (v) -> Object.prototype.toString.call(v) == "[object Object]"

	@isArray: (v) -> NodeUtil.isArray v

	@isString: (v) -> typeof v is 'string'
