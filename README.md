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
  config.app = 'TOKEN'
end
```

### Send message

```ruby
Phonify.send_message '+14560000000', 'As above, so below.'
```

### Verify

Send verification code

```ruby
Phonify.verify '+14560000000'
```

Verify

```ruby
Phonify.verify '+14560000000', '1234'
```

Authenticate

```ruby
Phonify.authenticate 'fclcw33ywA993tk5s1fs4n54d2ZjgA4r6xf3k4sA1cxw6926gckz2Ajxnz6n79Astl4fqbsnms4Adm1'
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

### Find subscriptions

Single subscription

```ruby
Phonify.subscription 'cVfZ4ehJ3g6c_1nvs47C'
```

All subscriptions

```ruby
Phonify.subscriptions
```

Returns array of subscriptions.

### Errors

See [Phonify API Errors](http://www.phonify.io/docs/api#errors).