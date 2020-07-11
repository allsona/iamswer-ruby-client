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
