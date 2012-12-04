
## Introduction

Phonify gem ads the power of Phonify service directly in your app. 

More info on [phonify.io/help](http://www.phonify.io/help).

## Installation

### Add gem to your Gemfile.

    gem "phonify"

*NOTE:* gem developers do this instead: ``gem 'phonify', :path => '/your/phonify/git-clone/path'``

### Install the gem

    bundle install

### Run generator to create local Phonify tables

    $ rails generate phonify 
          create  db/migrate/20121204172439_create_phonify_phones.rb
          create  db/migrate/20121204172440_create_phonify_messages.rb
          create  db/migrate/20121204172441_create_phonify_subscriptions.rb
          insert  app/models/user.rb
     initializer  phonify.rb

This will generate a config file ``config/initializers/phonify.rb`` where you can customize your settings

    # Campaign settings
    Phonify.config.campaign1 = 'CHANGEME'

    # API authentication
    Phonify.config.api_key = 'CHANGEME'

*NOTE:* You can also pass the campaign name, key and api key directly to the generate command

    rails generate phonify --campaign-name=mt --campaign-key=12345 --api-key=abcde

Which will generate config file ``config/initializers/phonify.rb`` as

    # Campaign settings
    Phonify.config.mt = '12345'

    # API authentication
    Phonify.config.api_key = 'abcde'

*NOTE:* If you have more than 1 campaign, just add more ``Phonify.config.campaign_name = 'key'`` configs to ``config/initializers/phonify.rb``

Migration files will also be generated. These tables store the necessary local references. The remaining object attributes will be fetched from phonify.io via API at runtime

    create_table :phonify_phones do |t|
      t.references :owner, :polymorphic => true
      t.string :campaign_id
      t.string :token
    end

    create_table :phonify_messages do |t|
      t.references :owner, :polymorphic => true
      t.integer :subscription_id
      t.integer :phone_id
      t.string :campaign_id
      t.string :token
    end

    create_table :phonify_subscriptions do |t|
      t.references :owner, :polymorphic => true
      t.integer :phone_id
      t.string :campaign_id
      t.string :token
      t.boolean :active
    end

Your current ``app/models/user.rb`` will also be configured to use phonify.io subscription

    class User < ActiveRecord::Base
      has_one :mt_subscription, as: "owner",
                                class_name: "Phonify::Subscription",
                                conditions: { campaign_id: Phonify.config.mt }

*NOTE:* If you have more than 1 campaign, just add more ``has_one …`` declarations with different ``campaign_id`` for the ``conditions`` hash.

*NOTE:* Instead of ``User``, you can specify a different model to modify, e.g. ``rails generate phonify Account`` will modify ``app/models/account.rb`` instead

### Migrate the database to create the tables.
    
    rake db:migrate

## Usage

Assuming your user model is ``User``

    user = User.find(1)

Creating a new subscription works the same way as a regular ActiveRecord ``has_one`` 

    user.create_mt_subscription(origin: { number: 646854345 }, service: { number: 7117, country: 'es' })
    => #<Phonify::Subscription :id => "ZNmtqyEcNPpAL8s4qxJv", :origin_phone => "646854345", :destination_phone => "7117", :active => false, :campaign_id => nil, :created_at => "2012-11-05 18:54:15", :updated_at => "2012-11-05 18:54:15">

Sending a message to your user is very simple

    user.mt_subscription.messages.create(message: "test message")
    => #<Phonify::Message :id => "KW9Aqn84ijagK6zseB5N", :message => "test message", :origin_phone => "7227", :destination_phone => "646854345", :delivered => false, :campaign_id => nil, :schedule_at => nil, :created_at => "2012-11-05 18:54:15", :updated_at => "2012-11-05 18:54:15">
