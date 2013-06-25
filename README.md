# Entrace

A tiny middleware that determines whether this request was from the internal network or not.

# Dependencies

actionpack

# Installation

```bash
gem install rack-entrance
````

# Usage

#### Add it to your middleware stack

```ruby
ENV['ENTRANCE_INTERNAL_IPS'] = "127.0.0.1,192.0.2.21"
use Rack::Entrance
````

#### Use it in your Controllers 

```ruby
request.env['entrance.internal']  #=> true/false
```
