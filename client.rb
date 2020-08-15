class Iamswer::Client
  include Singleton

  NONCE_HEADER = "X-Iamswer-Signature-Nonce".freeze

  class << self
    delegate :get,
      :post,
      :delete,
      to: :instance
  end

  def get(path, params = {})
    response = client.get path do |req|
      req.params.merge! params
    end

    JSON.parse(response.body).with_indifferent_access
  end

  def post(path, params = {})
    response = client.post path do |req|
      req.params.merge! params
    end

    JSON.parse(response.body).with_indifferent_access
  end

  def delete(path, params = {})
    response = client.delete path do |req|
      req.params.merge! params
    end

    JSON.parse(response.body).with_indifferent_access
  end

  def self.nonce_header
    NONCE_HEADER
  end

  def self.calculate_callback_nonce(secret_key, payload)
    digest = OpenSSL::Digest.new("sha256")
    hmac = OpenSSL::HMAC.digest(digest, secret_key, payload.to_json)
    Base64.strict_encode64(hmac)
  end

  private

    def endpoint
      Iamswer::Config.api_endpoint
    end

    def secret_key
      Iamswer::Config.secret_key
    end

    def client
      @client ||= begin
        Faraday.new(
          url: endpoint,
          params: {
            secret_key: secret_key
          },
          headers: {
            "Content-Type" => "application/json",
            "User-Agent" => "Iamswer Client 1.0",
          }
        )
      end
    end

end
