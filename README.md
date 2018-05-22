## Introduction

Phonify gem is an easy way to send SMS and verify phone numbers with global coverage from your app. 

More info on [phonify.io/help](http://www.phonify.io/help).

## Installation

### Add gem to your Gemfile

```ruby
gem 'phonify', github: 'pelcasandra/github'
```

### Install the gem

```ruby
bundle install
```

## Usage

Configure your api and app tokens:

```ruby    
# config/initializers/phonify.rb
Phonify.configure do |config|
  config.api_key = 'TOKEN'
end
```

### Send message

```ruby
Phonify.send_message '+14560000000', 'As above, so below.'
```

### Find messages

Single message

```ruby
Phonify.message '4g_oYIXRP6hRrUO0t9C'
```

All messages

```ruby
Phonify.messages
```

Returns array of messages

### Errors

See [Phonify API Errors](http://www.phonify.io/docs/api#errors).