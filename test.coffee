hubucket = require "./hubucket.coffee"
repo = hubucket.qualified_repo("pyro2927/evernote2box")
hubucket.get "repositories/#{repo}/events/", (events) ->
	console.log events