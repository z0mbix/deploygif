Get gifs when you deploy
========================

This is the application code for [deploygif.com](deploygif.com)

## Description

Fancy putting silly animated gifs in your HipChat/Slack rooms after a deploy, even if they fail?

When calling this service it will return a link to a random animated gif
relevant to the requested path (/success or /fail)

## Usage

You've done a successful deploy, celebrate by hitting:

    $ curl https://deploygif.com/success
    http://replygif.net/i/1072.gif

Your deploy didn't really go to plan, commiserate with:

    $ curl https://deploygif.com/fail
    http://replygif.net/i/902.gif

If you want a json response for some reason you can either add *json=1* to the query string:

    $ curl https://deploygif.io/success?json=1
    {"url":"http:\/\/cdn.thelisticles.net\/wp-content\/uploads\/2014\/11\/152.gif"}

or, send the *'application/json'* Accept header:

    $ curl https://deploygif.io/success -H 'Accept: application/json'
    {"url":"http:\/\/replygif.net\/i\/96.gif"}

or, just use the .json extension:

    $ curl https://deploygif.io/success.json
    {"url":"http:\/\/replygif.net\/i\/96.gif"}

