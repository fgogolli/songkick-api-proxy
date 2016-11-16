# songkick-api-proxy

## Overview

This repository contains a Vagrantfile and a puppet module which deploys a 
nginx caching proxy frontend for the Songkick API.

In order to test this proxy, you will need to:

1. Clone this repository.
2. Have `vagrant` installed, and using a provider (e.g. Virtualbox is default).
3. Run `vagrant up`.
4. Add a hosts entry for: `songkick-api-proxy  192.168.1.5`.
5. Test the songkick-api-proxy by accesing one of the API URLs in this format:
  *  `http://songkick-api-proxy:8080/api/3.0/artists/{artist_id}/calendar.json?apikey={your_api_key}`
  *  `http://songkick-api-proxy:8080/api/3.0/venues/{venue_id}/calendar.json?apikey={your_api_key}`