{{define "upstream_with_dummy"}}
  {{- $upstream := .}}
  {{- range service $upstream}}
    {{- $addressAndPort := (printf "%s:%d" .NodeAddress .Port) }}
    {{- scratch.MapSetX $upstream $addressAndPort $addressAndPort}}
  {{- end}}

  {{- executeTemplate "servers" (scratch.MapValues $upstream)}}
{{end}}

{{define "servers"}}
  {{ $addressAndPortPairs := . }}
  {{- range $addressAndPort := $addressAndPortPairs}}
  server {{$addressAndPort}} max_fails=0;
  {{- else}}
  server 127.0.0.1:65535; # force a 502
  {{- end}}
{{end}}


server {
  server_name localhost;
   location / {
    proxy_set_header Host $http_host;
    proxy_http_version 1.1;
    proxy_pass $scheme://app;
    proxy_next_upstream error timeout http_502 http_503 http_504;
    proxy_next_upstream_timeout 40s;
    proxy_next_upstream_tries 5;
    proxy_pass_request_headers on;
  }
  access_log /dev/stdout main;
  error_log /dev/stdout info;
}

upstream app {
  {{- executeTemplate "upstream_with_dummy" (printf "rails.app") }}
}
