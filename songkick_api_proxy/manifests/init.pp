# === Class: songkick_api_proxy
#
# This module deploys an nginx server as a reverse proxy with caching
# for the Songkick API.
#
# === Parameters
#
# [*api_upstream*]
#   The upstream API URL. Default: 'api.songkick.com'
#
# [*api_upstream_port*]
#   The upstream API Port. Default: '80'
#
# [*api_vhost*]
#   The local virtual host address. Default: 'songkick-api-proxy'
#
# [*api_vhost_port*]
#   The local virtual host port. Default: '8080'
#
# [*upstream_protocol*]
#   The upstream protocol. Default: 'http'
#
# [*upstream_proxy*]
#   The nginx upstream name. Default: 'songkick-api'
#
# [*api_root_loc*]
#   The nginx API root location. Default: '/api'
#
# [*api_artists_loc*]
#   The nginx API artists location. Default: '/api/3.0/artists'
#
# [*api_venues_loc*]
#   The nginx API venues location. Default: '/api/3.0/venues'
#
# [*proxy_cache_path*]
#   The nginx proxy cache path. Default: '/var/cache/nginx'
#
# [*proxy_cache_key*]
#   The nginx Songkick API proxy cache name. Default: 'songkick_api'
#
# [*proxy_cache_size*]
#   The nginx Songkick API proxy cache size. Default: '100m'
#
# [*proxy_cache_levels*]
#   The nginx Songkick API proxy cache levels. Default: '1:2'
#
# [*proxy_cache_valid*]
#   The nginx Songkick API proxy cache validity. Default: '12h'
#
# [*proxy_cache_methods*]
#   The proxy HTTP request methods to cache. Default: 'GET;'
#
# [*proxy_add_header*]
#   The HTTP cache header to be returned to clients. Default: 
#   'X-Proxy-Cache $upstream_cache_status;'
#
# [*proxy_ignore_headers*]
#   The HTTP headers to be ignored by proxy. Default: 
#   'X-Accel-Expires Expires Cache-Control Set-Cookie;'
#
# [*allow_ranges*]
#   The IP ranges that should be allowed to access the proxy. Default: 
#
#  [
#    '127.0.0.1/8',
#    '192.168.1.0/29', 
#  ]
#
# [*proxy_set_header*]
#   The proxy headers that should be attached to the requests to upstream. Default: 
#
#  [
#    'Host api.songkick.com',
#    'X-Real-IP $remote_addr',
#    'X-Forwarded-For $proxy_add_x_forwarded_for',
#  ],
#
# === Examples
#
#  class { 'songkick_api_proxy': }
#
# === Authors
#
# Flamur Gogolli <flamur.gogolli@gmail.com>
#
# === Copyright
#
# Copyright 2016 Flamur Gogolli
#
class songkick_api_proxy (
  $api_upstream          = 'api.songkick.com',
  $api_upstream_port     = '80',
  $api_vhost             = 'songkick-api-proxy',
  $api_vhost_port        = '8080',
  $upstream_protocol     = 'http',
  $upstream_proxy        = 'songkick-api',
  $api_root_loc          = '/api',
  $api_artists_loc       = '/api/3.0/artists',
  $api_venues_loc        = '/api/3.0/venues',
  $proxy_cache_path      = '/var/cache/nginx',
  $proxy_cache_key       = 'songkick_api',
  $proxy_cache_size      = '100m',
  $proxy_cache_levels    = '1:2',
  $proxy_cache_valid     = '12h',
  $proxy_cache_methods   = 'GET;',
  $proxy_add_header      = 'X-Proxy-Cache $upstream_cache_status;',
  $proxy_ignore_headers  = 'X-Accel-Expires Expires Cache-Control Set-Cookie;',
  $allow_ranges          = [
    '127.0.0.1/8',
    '192.168.1.0/29',
  ],
  $proxy_set_header      = [
    'Host api.songkick.com',
    'X-Real-IP $remote_addr',
    'X-Forwarded-For $proxy_add_x_forwarded_for',
  ],
){

  $allow_cfg = {
    'allow' => $allow_ranges,
    'deny'  => 'all'
  }

  $proxy_cfg = {
    'proxy_cache_methods'  => $proxy_cache_methods,
    'add_header'           => $proxy_add_header,
    'proxy_ignore_headers' => $proxy_ignore_headers,
  }

  class { '::nginx':
    proxy_cache_path      => $proxy_cache_path,
    proxy_cache_keys_zone => "${proxy_cache_key}:${proxy_cache_size}",
    proxy_cache_levels    => $proxy_cache_levels,
    proxy_set_header      => $proxy_set_header,
  }

  nginx::resource::upstream { $upstream_proxy:
    members => [
      "${api_upstream}:${api_upstream_port}",
    ],
  }

  nginx::resource::vhost { $api_vhost:
    listen_port      => $api_vhost_port,
    proxy            => "${upstream_protocol}://${upstream_proxy}",
    vhost_cfg_append => $allow_cfg,
  }

  nginx::resource::location{$api_root_loc:
    vhost    => $api_vhost,
    location => $api_root_loc,
    proxy    => "${upstream_protocol}://${upstream_proxy}${api_root_loc}",
  }

  nginx::resource::location{$api_artists_loc:
    vhost                      => $api_vhost,
    location                   => $api_artists_loc,
    proxy                      => "${upstream_protocol}://${upstream_proxy}${api_artists_loc}",
    proxy_cache                => $proxy_cache_key,
    proxy_cache_valid          => $proxy_cache_valid,
    location_custom_cfg_append => $proxy_cfg,
  }

  nginx::resource::location{$api_venues_loc:
    vhost                      => $api_vhost,
    location                   => $api_venues_loc,
    proxy                      => "${upstream_protocol}://${upstream_proxy}${api_venues_loc}",
    proxy_cache                => $proxy_cache_key,
    proxy_cache_valid          => $proxy_cache_valid,
    location_custom_cfg_append => $proxy_cfg,
  }
}