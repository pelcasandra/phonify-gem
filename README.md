
## Introduction

Phonify gem adds the power of Phonify service directly in your app. More info on [phonify.io/help](http://www.phonify.io/help).

## Installation

Framework independent.

### Add gem to your Gemfile.

    gem 'phonify'

### Install the gem

    bundle install

## Usage

Configure your token
    
    Phonify.config.token = 'TOKEN'

Check if the subscription is active

    Phonify.subscription_active? '1234', '+34670000000', 'KEYWORD'

Send subscription message

    Phonify.send_subscription_message '1234', '+34670000000', 'KEYWORD', 'BODY'
