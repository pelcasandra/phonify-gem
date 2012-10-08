
## Introduction

Phonify gem ads the power of Phonify service directly in your app. 

More info on [phonify.io/help](http://www.phonify.io/help).

## Installation

Add gem to your Gemfile.

    gem "phonify"

Install the gem

    bundle install

Place the following code at the end of `config/application.rb` 

    Phonify.config = {
      :api_key => {VALUE},
      :campaign_id => optional
    }

Run generator to create local Phonify tables

    rake generate phonify

Run migrations
    
    rake db:migrate

## Usage

### Simple Usage

Send a message

    Phonify::Message.new("646854345", "test message")

Find a message

    Phonify::Message.find("KW9Aqn84ijagK6zseB5N")

Creating a new subscription is very simple. 

    Phonify::Subscription.new("646854345")

### Extending Models

Phonify can be extended to your application models using any Message, Phone or Subscription resource. You can use `extend Phonify :resource`.

The following example will relate your User object with a Phonify subscription. 

    # user.rb
    extend Phonify :subscription

Requesting all messages and subscriptions from any user

    a = User.find(1).messages
    a = User.find(1).subscriptions

Sending a message directly to a user is also easy if in this case (considering a Subscription belongs to a campaign)

    a = User.find(1).send_message("Testing message directly to user")

## Settings

    rake phonify:pull   # will copy results from the cloud