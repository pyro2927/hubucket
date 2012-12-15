http = require "scoped-http-client"
async = require "async"
querystring = require "querystring"

process.env.HUBOT_CONCURRENT_REQUESTS ?= 20

class BitBucket
  constructor: (@logger) ->
    @requestQueue = async.queue (task, cb) =>
      task.run cb
    , process.env.HUBOT_CONCURRENT_REQUESTS
  qualified_repo: (repo) ->
    unless repo?
      unless (repo = process.env.HUBOT_GITHUB_REPO)?
        @logger.error "Default BitBucket repo not specified"
        return null
    repo = repo.toLowerCase()
    return repo unless repo.indexOf("/") is -1
    unless (user = process.env.HUBOT_BITBUCKET_USER)?
      @logger.error "Default BitBucket user not specified"
      return repo
    "#{user}/#{repo}"
  request: (verb, url, data, cb) ->
    unless cb?
      [cb, data] = [data, null]

    url_api_base = process.env.HUBOT_GITHUB_API || "https://api.bitbucket.org/1.0"

    if url[0..3] isnt "http"
      url = "/#{url}" unless url[0] is "/"
      url = "#{url_api_base}#{url}"
    req = http.create(url)
    
    unless (user = process.env.HUBOT_BITBUCKET_USER)?
      @logger.error "Default BitBucket user not specified"
    unless (password = process.env.HUBOT_BITBUCKET_PASSWORD)?
      @logger.error "Default BitBucket password not specified"
    authString = "#{user}:#{password}"

    base64 = new Buffer(authString).toString('base64');
    req = req.header("Authorization", "Basic #{base64}")
    args = []
    args.push JSON.stringify data if data?
    args.push "" if verb is "DELETE" and not data?
    task = run: (cb) -> req[verb.toLowerCase()](args...) cb
    @requestQueue.push task, (err, res, body) =>
      return @logger.error err if err?

      try
        data = JSON.parse body if body
      catch e
        return @logger.error "Could not parse response: #{body}"

      if (200 <= res.statusCode < 300)
        cb data
      else
        @logger.error "#{res.statusCode} #{data.message}"
  get: (url, data, cb) ->
    unless cb?
      [cb, data] = [data, null]
    if data?
      url += "?" + querystring.stringify data
    @request "GET", url, cb
  post: (url, data, cb) ->
    @request "POST", url, data, cb

module.exports = bitbucket = (robot) ->
  new BitBucket robot.logger

bitbucket[method] = func for method,func of BitBucket.prototype

bitbucket.logger = {
  error: (msg) ->
    util = require "util"
    util.error "ERROR: #{msg}"
  debug: ->
}

bitbucket.requestQueue = async.queue (task, cb) =>
  task.run cb
, process.env.HUBOT_CONCURRENT_REQUESTS
