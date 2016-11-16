# songkick\_api\_proxy

## Overview

This puppet module deploys a nginx caching proxy frontend for the Songkick API.
The following actions are taken:

* The upstream `puppet-nginx` puppet module is used to handle the nginx setup, while
  the `fgogolli-songkick_api_proxy` puppet module serves as a wrapper to handle the
  specific use-case for songkick-api-proxy.
* A nginx vhost is created serving under the hostname and port: `http://songkick-api-proxy:8080`.
* Three separate nginx vhost locations are created under: `/api`, `/api/3.0/artists`, and `/api/3.0/venues`.
* Access to the vhost is only allowed from: `127.0.0.1/8`, and `192.168.1.0/29` (192.168.1.0 - 192.168.1.7).
* The GET requests to the `/api/3.0/artists` and `/api/3.0/venues` locations 
  are cached for 12 hours.
* The `X-Proxy-Cache` HTTP Header is added to nginx responses to describe the
  caching status of a request.