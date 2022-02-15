#!/bin/sh
docker run --network evolve-apis_default --rm curlimages/curl:7.81.0 -v -i http://apisix:9080/apisix/admin/plugins/reload -H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' -X PUT

docker run --network evolve-apis_default --rm curlimages/curl:7.81.0 -v -i http://apisix:9080/apisix/admin/plugin_configs/1 -H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' -X PATCH -d '
{
 "plugins": {
    "prometheus": {},
    "serverless-pre-function": {
        "phase": "rewrite",
        "functions" : ["return function() local uri = ngx.re.sub(ngx.var.uri, \"/v1/(.*)\", \"/$1\", \"o\"); ngx.req.set_uri(uri); end"]
    },
    "unauth-limit": {
      "count": 1,
      "time_window": 60,
      "key_type": "var",
      "key": "consumer_name",
      "rejected_code": 429,
      "rejected_msg": "Please register at https://apisix.org/register to get your API token and enjoy unlimited calls"
    },
    "proxy-mirror": {
      "host": "http://new.api:8082"
    }
  }
}'
