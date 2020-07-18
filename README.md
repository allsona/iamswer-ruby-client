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

3. Write the config, typically something like:

   ```rb
   Iamswer::Config.configure do |c|
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

4. Install dependencies:
   - Faraday

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
  <summary>How to express ownership of an object?</summary>
  <p>

  ```ruby
  class Organization
    include Iamswer::User::Belonging

    owned_by User
  end
  ```

  We may also define a field name like this:

  ```ruby
  owned_by User, field_name: :owner
  ```

  </p>

  Note: ensure you have created the `User` model class!
</details>

