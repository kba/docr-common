module.exports =
	Config : require './config'
	Jobs : require './queue'
	Models :
		OcrJob: require './models/ocr-job'
