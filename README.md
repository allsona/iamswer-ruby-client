# Iamswer Ruby Client

The client for Iamswer -- A user microservice

## Installation

1. Add as submodule in your app's `lib` folder:

   ```
   git submodule add git@github.com:allsona/iamswer-ruby-client iamswer
   ```

2. Create a `config/initializers/0lib_loader.rb` with the following code:

   ```ruby
   loader = Zeitwerk::Loader.new
   loader.push_dir(Rails.root.join("lib"))
   loader.enable_reloading
   loader.setup
   loader.reload
   loader.eager_load
   ```

3. Creates a user class that includes `Iamswer::User::Prototype`. Actually, this is an optional step, but is considered a good practice, so that you can customize the `User` class anyway you want.

   ```rb
   class User
     include Iamswer::User::Prototype

     # you can use iamswer_fields to define fields you want to use
     # you can use iamswer_extra_fields to define extra fields
     # by default, created_at, updated_at, and locale is included
   end
   ```
   
4. Include `Iamswer::SessionHandler` into the `ApplicationController` (provides a way to call `current_user`):

   ```rb
   class ApplicationController < ActionController::Base
     include Iamswer::SessionHandler
   end
   ```

5. Write the config, typically something like:

   ```rb
   Iamswer::Config.configure do |c|
     c.user_class = "User" # if you defined the user class
     c.subdomain = "sonasign"

     if Rails.env.development?
       c.endpoint = "http://sonasign.sonasign.me:3001"
       c.api_endpoint = "http://iamswer-web:3001"
       c.secret_key = "SONASIGN_SECRET_KEY"
       c.session_key_base = "SONASIGN_KEY_BASE"
     else
       c.endpoint = "https://id.sonasign.com"
       c.secret_key = ENV["IAMSWER_SECRET_KEY"]
       c.session_key_base = ENV["IAMSWER_SESSION_KEY_BASE"]
     end
   end
   ```

6. Install dependencies by adding them into `Gemfile`:

   ```ruby
   gem "faraday"
   gem "connection_pool"
   gem "hiredis", "~> 0.6"
   gem "redis", ">= 3.2.0", require: ["redis", "redis/connection/hiredis"]
   ```

## Simple guide

<details>
  <summary>How to represent a user with a model?</summary>
  <p>

  ```ruby
  class User
    include Iamswer::User::Prototype

    # list the native fields you would like to use
    iamswer_fields :id,
      :email,
      :name

    # list the additional extra fields
    iamswer_extra_fields :is_public
  end
  ```

  </p>
</details>


<details>
  <summary>How to express ownership of an object to the User class?</summary>
  <p>
  We can use `owned_by`. Let's assume an `Organization` is owner by a user, we can express that as follows:

  ```ruby
  class Organization
    include Iamswer::User::Belonging

    owned_by User
  end
  ```

  We may also define the relationship as follows:

  ```ruby
  owned_by User, field_name: :owner
  ```

  </p>

  Note: ensure you have created the `User` model class!
</details>


<details>
  <summary>How to express the `has_many` ownership?</summary>
  <p>
  We simply use `has_many` on the `User` class as follows:

  ```ruby
  class User
    include Iamswer::User::Prototype

    has_many :organizations
  end
  ```

  </p>
</details>
