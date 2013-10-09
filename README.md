
## Introduction

Phonify gem ads the power of Phonify service directly in your app. 

More info on [phonify.io/help](http://www.phonify.io/help).

## Installation

Rails 4 compatible.

### Add gem to your Gemfile.

    gem "phonify"

*NOTE:* gem developers do this instead: ``gem 'phonify', :path => '/your/phonify/git-clone/path'``

### Install the gem

    bundle install

### Run generator to setup your app

    $ rails generate phonify 
          create  db/migrate/20121204172439_create_phonify_phones.rb
          create  db/migrate/20121204172440_create_phonify_messages.rb
          create  db/migrate/20121204172441_create_phonify_subscriptions.rb
          insert  app/models/user.rb
     initializer  phonify.rb

This will generate a config file ``config/initializers/phonify.rb`` where you can customize your settings

    # App settings
    Phonify.config.app1 = 'CHANGEME'

    # API authentication
    Phonify.config.api_key = 'CHANGEME'

Do not forget to run migrations. 

    rake db:migrate

These tables store the necessary local references. The remaining object attributes will be fetched from phonify.io via API at runtime

Your current ``app/models/user.rb`` will also be configured to use phonify.io subscription

    class User < ActiveRecord::Base
      has_one :app1_subscription, as: "owner",
                                       class_name: "Phonify::Subscription",
                                       conditions: { app_id: Phonify.config.app1 }

##### Options

You can also be explicit about the user class name, or provide the app name, key and your api key directly to the generate command, e.g.

    rails generate phonify Account --app-name=monthly --app-key=AAA --api-key=BBB

Which will generate config file ``config/initializers/phonify.rb`` as

    # App settings
    Phonify.config.monthly = 'AAA'

    # API authentication
    Phonify.config.api_key = 'BBB'

And configure ``app/models/account.rb`` as

    class Account < ActiveRecord::Base
      has_one :monthly_subscription, -> { where(app_id: Phonify.config.monthly) },
                                     as: "owner",
                                     class_name: "Phonify::Subscription"
                                       

*NOTE:* If you have more than 1 app, just add more ``Phonify.config.app_name = 'key'`` configs to ``config/initializers/phonify.rb`` and add more ``has_one …`` declarations with different ``app_id`` for the ``conditions`` hash.

### Migrate the database to create the tables.
    
    rake db:migrate

## Usage

Assuming your user model is ``User`` and app name is ``monthly``

    john = User.find(1)

Creating a new subscription works the same way as a regular ActiveRecord ``has_one`` 

    john.create_monthly_subscription(origin: "349123456789", service: "+3477555")
    => #<Phonify::Subscription :id => "ZNmtqyEcNPpAL8s4qxJv", ...>

Note that the phone numbers must be msisdn (prefixed with country code, area code). Alternatively, if country and carrier information is available, they can be provided

    john.create_monthly_subscription(origin: { number: "9123456789", country: "es", carrier: "movistar" }, service: { number: "77555", country: "es", carrier: "movistar" })
    => #<Phonify::Subscription :id => "ZNmtqyEcNPpAL8s4qxJv", ...>

Sending a message to your user is very simple

    john.monthly_subscription.messages.create(message: "test message")
    => #<Phonify::Message :id => "KW9Aqn84ijagK6zseB5N", ...>
