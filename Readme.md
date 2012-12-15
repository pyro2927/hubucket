# A Hubot-compatible BitBucket API wrapper for Node.js #

## Install ##

    npm install githubot

## Require ##

Use it in your Hubot script:

```coffeescript
module.exports = (robot) ->
  bitbucket = require('hubucket')(robot)
```

Or use it on its own:

```coffeescript
bitbucket = require('hubucket')
```

## Use ##

Make any call to the Github v3 API, get the parsed JSON response:

```coffeescript
github.get "https://api.github.com/users/iangreenleaf/gists", (gists) ->
  console.log gists[0].description

github.get "users/foo/repos", {type: "owner"}, (repos) ->
  console.log repos[0].url

data = { description: "A test gist", public: true, files: { "abc.txt": { content: "abcdefg" } } }
github.post "gists", data, (gist) ->
  console.log gist.url
```

## Authentication ##

If `process.env.HUBOT_BITBUCKET_USER` and `process.env.HUBOT_BITBUCKET_PASSWORD` are present, you're automatically authenticated. Sweet!