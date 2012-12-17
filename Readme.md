# A Hubot-compatible BitBucket API wrapper for Node.js #

## Install ##

    npm install hubucket

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

Make any call to the BitBucket v1.0 API, get the parsed JSON response:

```coffeescript
bitbucket.get 'repositories/pyro2927/evernote2box/events/' (data) ->
    console.log data
```

## Authentication ##

If `process.env.HUBOT_BITBUCKET_USER` and `process.env.HUBOT_BITBUCKET_PASSWORD` are present, you're automatically authenticated. Sweet!
