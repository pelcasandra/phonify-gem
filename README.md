
## Introduction

Phonify gem adds the power of Phonify service directly in your app. More info on [phonify.io/help](http://www.phonify.io/help).

## Installation

Framework independent.

### Add gem to your Gemfile

    gem 'phonify', github: 'pelcasandra/github'

### Install the gem

    bundle install

## Usage

Configure your api and app tokens:
    
    Phonify.token = 'TOKEN'
    Phonify.app = 'TOKEN'

### Messages    

Send message:

    Phonify.send_message '+34670000000', 'BODY'

You can also send a message specifying any keyword or short code assigned.

    Phonify.send_message '+34670000000', 'BODY', {
    	keyword: "COUPONS",
    	origin: "1616",
    	country: "UY"
    }


### Subscriptions

Check if the subscription is active:

    Phonify.subscription_active? '+34670000000'

Create a subscription

    Phonify.create_subscription '+34670000000'

Cancel a subscription    

    Phonify.cancel_subscription '+34670000000'