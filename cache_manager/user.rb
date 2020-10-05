module Iamswer::CacheManager::User
  extend self

  def reference_key user_id
    "User##{user_id}"
  end

  def key_on_id user_id
    "User#id=#{user_id}"
  end

  def key_on_email user_email
    "User#email=#{user_email}"
  end

  def key_on_username username
    "User#username=#{username}"
  end

  # for space-efficiency, we want all related data to
  # refer to the same reference key. so rather than storing
  # each record and associating it one-by-one based on the
  # is, email and username, we record them under the same
  # reference. those finders then fetch by the reference
  def find_by_reference_key reference_key
    return unless Iamswer::CacheManager.enabled?

    if reference_key.present?
      serialized_data = Iamswer::CacheManager.get reference_key
      deserialize(serialized_data)
    end
  end

  def find_by_id user_id
    return unless Iamswer::CacheManager.enabled?

    find_by_reference_key Iamswer::CacheManager.get(key_on_id(user_id))
  end

  def find_by_email email
    return unless Iamswer::CacheManager.enabled?

    find_by_reference_key Iamswer::CacheManager.get(key_on_email(email))
  end

  def find_by_username username
    return unless Iamswer::CacheManager.enabled?

    find_by_reference_key Iamswer::CacheManager.get(key_on_username(username))
  end

  def cache user
    unless user.is_a? Iamswer::User
      user = user.iamswer_user
    end

    return unless Iamswer::CacheManager.enabled?

    refkey = reference_key(user.id)
    Iamswer::CacheManager.set refkey, serialize(user)
    Iamswer::CacheManager.set key_on_id(user.id), refkey
    Iamswer::CacheManager.set key_on_email(user.email), refkey
    Iamswer::CacheManager.set key_on_username(user.username), refkey

    true
  end

  def serialize user
    user.attributes(json_compatible: true).to_json
  end

  def deserialize json_string
    data = JSON.parse(json_string).with_indifferent_access
    Iamswer::User.new_from_json data
  end
end
