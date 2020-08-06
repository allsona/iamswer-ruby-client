# A specific module that makes it easier to test systems
# that are integrated with Iamswer
module Iamswer::Test
  include Iamswer::Test::Mock
  include Iamswer::Test::Cookies

  class << self
    include Iamswer::Test::Mock
    include Iamswer::Test::Cookies
  end
end
