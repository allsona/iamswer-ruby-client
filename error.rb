class Iamswer::Error < StandardError
  DslError          = Class.new self
  InternalError     = Class.new self
  InvalidRecord     = Class.new self
  InvalidRequest    = Class.new self
  MissingRecord     = Class.new self
  NotUniqueRecord   = Class.new self
  OtherError        = Class.new self
  Unauthorized      = Class.new self
  TypeError         = Class.new self

  def self.from_code(code)
    class_name = code.downcase.classify
    "Iamswer::Error::#{class_name}".constantize
  rescue
    OtherError
  end

  def self.from(error)
    code = error["code"]
    message = error["message"]

    Iamswer::Error.from_code(code).new(message)
  end

  # TODO: code to subscribe for event that register error
  # contexts. We would like to decouple Iamswer from error
  # reporting system such as Sentry, for example.
  def self.add_context attributes
  end

  def self.on_context_added &block
  end
end
