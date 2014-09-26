[![Build Status](https://travis-ci.org/bukowskis/rack-entrance.png)](https://travis-ci.org/bukowskis/rack-entrance)

# Entrace

A tiny middleware that determines whether this request was from the internal network or not.

# Installation

```bash
gem install rack-entrance
````

# Usage

#### Add it to your middleware stack

```ruby
ENV['ENTRANCE_INTERNAL_CIDRS'] = "127.0.0.1/32,192.0.2.21/24"
use Rack::Entrance
````

#### Use it in your Controllers

```ruby
request.env['entrance.internal']  #=> true/false
```
