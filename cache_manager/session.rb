module Iamswer::CacheManager::Session
  extend self

  def key_on_id session_id
    "Session#id=#{session_id}"
  end

  def find_by_id session_id
    return unless Iamswer::CacheManager.enabled?

    serialized_data = Iamswer::CacheManager.get key_on_id(session_id)
    deserialize(serialized_data) if serialized_data
  end

  def cache session
    return unless Iamswer::CacheManager.enabled?

    Iamswer::CacheManager.set key_on_id(session.id), serialize(session)

    true
  end

  def serialize session
    user = session.user
    user = user.iamswer_user unless user.is_a?(Iamswer::User)
    Iamswer::CacheManager.cache! user

    serialized = session.attributes(json_compatible: true)
    serialized[:user] = Iamswer::CacheManager::User.reference_key(user.id)
    serialized.to_json
  end

  def deserialize json_string
    data = JSON.parse(json_string).with_indifferent_access
    user_refkey = data["user"]

    return nil unless user_refkey.present?

    user = Iamswer::CacheManager::User.find_by_reference_key(user_refkey)
    data[:user] = user.attributes(json_compatible: true)

    Iamswer::Session.new_from_json data
  end
end
