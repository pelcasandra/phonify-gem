
## Introduction

Phonify gem adds the power of Phonify service directly in your app. More info on [phonify.io/help](http://www.phonify.io/help).

## Installation

Framework independent.

### Add gem to your Gemfile

    gem 'phonify', github: 'pelcasandra/github'

### Install the gem

    bundle install

## Usage

Configure your token:
    
    Phonify.token = 'TOKEN'

Check if the subscription is active:

    Phonify.subscription_active? 'APP_TOKEN', '+34670000000'

Send subscription message:

    Phonify.send_subscription_message 'APP_TOKEN', '+34670000000', 'BODY'
