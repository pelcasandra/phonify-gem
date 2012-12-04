
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

    rails generate phonify
    
This will generate a migration file to store the necessary local references.

    create_table :phonify_phones do |t|
      t.references :owner, :polymorphic => true
      t.string :token
    end

    create_table :phonify_messages do |t|
      t.references :owner, :polymorphic => true
      t.string :token
    end

    create_table :phonify_subscriptions do |t|
      t.references :owner, :polymorphic => true
      t.string :token
    end

As well as ActiveRecord models which you can customize (all of the logic is already encapsulated in the super class)

    class Phone < Phonify::Phone
    end

    class Message < Phonify::Message
    end

    class Subscription < Phonify::Subscription
    end

Run migrations
    
    rake db:migrate

## Usage

### Simple Usage

Sending a message is very simple

    Phonify::Message.new("646854345", "test message")
    => #<Message :id => "KW9Aqn84ijagK6zseB5N", :message => "test message", :origin_phone => "7227", :destination_phone => "646854345", :delivered => false, :campaign_id => nil, :schedule_at => nil, :created_at => "2012-11-05 18:54:15", :updated_at => "2012-11-05 18:54:15">

Find a message

    Phonify::Message.find("KW9Aqn84ijagK6zseB5N")
    => #<Message :id => "KW9Aqn84ijagK6zseB5N", :message => "test message", :origin_phone => "7227", :destination_phone => "646854345", :delivered => false, :campaign_id => nil, :schedule_at => nil, :created_at => "2012-11-05 18:54:15", :updated_at => "2012-11-05 18:54:15">

Creating a new subscription is very easy too. 

    Phonify::Subscription.new("646854345","7117")
    => #<Subscription :id => "ZNmtqyEcNPpAL8s4qxJv", :origin_phone => "646854345", :destination_phone => "7117", :active => false, :campaign_id => nil, :created_at => "2012-11-05 18:54:15", :updated_at => "2012-11-05 18:54:15">

### Extending Models

Phonify can be extended to your application models using any Message, Phone or Subscription resource. You can use `has_phonify :resource`.

The following example will relate your User object with Phonify subscriptions and messages. 

    class User < ActiveRecord::Base
      has_many :subscriptions
      has_many :messages
    end

Requesting all messages and subscriptions from any user

    a = User.find(1).messages
    a = User.find(1).subscriptions

Sending a message directly to a user is also easy if in this case (considering a Subscription belongs to a campaign)

    a = User.find(1).send_message("Testing message directly to user")

## Settings

    rake phonify:pull   # will copy results from the cloud
