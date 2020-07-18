module Iamswer::UrlHelpers
  extend self

  def root_endpoint
    @root_endpoint ||= begin
      endpoint = Iamswer::Config.instance.endpoint
      endpoint[-1] == "/" ? endpoint[0..-2] : endpoint
    end
  end

  def sign_out_url
    root_endpoint + "/sessions/sign_out"
  end
end
