## Introduction

Phonify gem is an easy way to send SMS and verify phone numbers with global coverage from your app. More info on [phonify.io/help](http://www.phonify.io/help).

## Installation

### Add gem to your Gemfile

    gem 'phonify', github: 'pelcasandra/github'

### Install the gem

    bundle install

## Usage

Configure your api and app tokens:
    
    # config/initializers/phonify.rb
    Phonify.api_key = 'TOKEN'
    Phonify.app = 'TOKEN'

### Send message

    Phonify.send_message '+14560000000', 'BODY'

Response

    {
      "message":
        {
          "id": "ch_0UVaSlPypmXHLS",
          "body": "This is a message",
          "to": "+14560000000",
          "phone": {
            "id": "ch_0UVaSlPypmXHLS",
            "number": "4560000000",
            "country": "US",
            "carrier": "att",
          },
          "app_id": "Asy_1KP3NNslAeBGhhjV",
          "sent": true,
          "amount": "0",
          "currency": "USD",
          "created_at": "2015-07-16T07:56:06.902Z"
      }
    }


### Verify

#### Send verification code

    Phonify.verify '+14560000000'

Response

    {
      "msisdn":"+14560000000",
      "app_id":"KW9Aqn84ijagK6zseB5N",
      "state":"initiated",
      "description": "Code sent to +14560000000."
    }

#### Verify

    Phonify.verify '+14560000000', '1234'

Response

    {
      "msisdn":"+14560000000",
      "app_id":"KW9Aqn84ijagK6zseB5N",
      "subscription_id":"4g_oYIXRP6hRrUO0t9C",
      "authentication_token":"fclcw33ywA993tk5s1fs4n54d2ZjgA4r6xf3k4sA1cxw6926gckz2Ajxnz6n79Astl4fqbsnms4Adm1",
      "state":"verified"
    }

#### Authenticate

    Phonify.authenticate '+14560000000', '1234'

Response

    {
      "msisdn":"+14560000000",
      "app_id":"KW9Aqn84ijagK6zseB5N",
      "subscription_id":"4g_oYIXRP6hRrUO0t9C",
      "state":"verified"
    }

### Find messages

#### Single message

    Phonify.find_message '+14560000000', '1234'

Response

    {
      "message":
        {
          "id": "ch_0UVaSlPypmXHLS",
          "body": "This is a message",
          "to": "+14560000000",
          "phone": {
            "id": "ch_0UVaSlPypmXHLS",
            "number": "4560000000",
            "country": "US",
            "carrier": "att",
          },
          "app_id": "Asy_1KP3NNslAeBGhhjV",
          "sent": true,
          "currency": "USD",
          "created_at": "2015-07-16T07:56:06.902Z"
      }
    }

#### All messages

    Phonify.messages

Returns array of messages

### Find phones

#### Single message

    Phonify.find_message '+14560000000'

Returns

    { 
      "phone":
       {
        "id": "ch_0UVaSlPypmXHLS",
        "msisdn": "+14560000000",                              
        "number": 4560000000,
        "country": "US",
        "carrier": "movistar",
        "app_id": "Asy_1KP3NNslAeBGhhjV",
        "state": "subscribed",
        "affiliate": "",
        "track": "",
        "created_at": "2015-07-16T07:56:06.902Z"
      }
    }

#### All phones

    Phonify.phones

Returns array of phones.

### Errors

See [Phonify API Errors](http://www.phonify.io/docs/api#errors).