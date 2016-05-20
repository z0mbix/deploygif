-- This is the regex match ($1) from the location regex (success|fail)
local route = ngx.var[1]
-- This is the regex match ($2) from the location regex (/|.json)
local match_group2 = ngx.var[2]
local redirect = ngx.var.arg_redirect
local json = ngx.var.arg_json
local cjson = require "cjson"
local redis = require "resty.redis"
local red = redis:new()
local accept_header = ngx.req.get_headers()["Accept"]

ngx.header["content-type"] = "text/plain"

red:set_timeout(1000) -- 1 sec

-- TODO: How to load settings from a config file?
local ok, err = red:connect("127.0.0.1", 6379)
if not ok then
    ngx.status = 503
    ngx.say("I'm terribly sorry, I messed something up :(")
    ngx.exit(ngx.OK)
end

local res, err = red:srandmember(route)

-- Did the request end with .json?
if match_group2 == '.json' then
    json = '1'
end

-- Did the request end with .gif?
if match_group2 == '.gif' then
    redirect = '1'
end

-- Did the request ask for json?
if accept_header == 'application/json' then
    json = '1'
end

-- Did I do something stupid?
if not res then
    ngx.say("Failed to find you a gif: ", err)
    return
end

-- Nothing back from redis?
if res == ngx.null then
    ngx.say("Sorry, no gifs found.")
    return
end

-- Put it into the connection pool of size 100,
-- with 10 seconds max idle time
local ok, err = red:set_keepalive(10000, 100)
if not ok then
    ngx.say("failed to set keepalive: ", err)
    return
end

if redirect == '1' then
    ngx.redirect(res, 302);
else
    if json == '1' then
        ngx.header["content-type"] = "application/json"
        json_res = { url = res }
        ngx.say(cjson.encode(json_res))
    else
        ngx.say(res)
    end
end

red:close()
ngx.exit(ngx.OK)
