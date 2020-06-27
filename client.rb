class Zenta::Client
  include Singleton

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

  private

    def endpoint
      ENV.fetch("ZENTA_ENDPOINT")
    end

    def secret_key
      ENV.fetch("ZENTA_SECRET_KEY")
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
            "User-Agent" => "Zenta Client 1.0",
          }
        )
      end
    end

end
