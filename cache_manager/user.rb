module Iamswer::CacheManager::User
  extend self

  def key_on_id user_id
    "User#id=#{user_id}"
  end

  def key_on_email user_email
    "User#email=#{user_email}"
  end

  def key_on_username username
    "User#username=#{username}"
  end

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

    reference_key = "User##{user.id}"
    Iamswer::CacheManager.set reference_key, serialize(user)
    Iamswer::CacheManager.set key_on_id(user.id), reference_key
    Iamswer::CacheManager.set key_on_email(user.email), reference_key
    Iamswer::CacheManager.set key_on_username(user.username), reference_key

    true
  end

  def serialize user
    {
      id: user.id, # string
      email: user.email,
      extra_fields: user.extra_fields,
      first_name: user.first_name,
      last_name: user.last_name,
      locale: user.locale,
      name: user.name,
      roles: user.roles,
      created_at: user.created_at.to_s,
      updated_at: user.updated_at.to_s,
    }.to_json
  end

  def deserialize json_string
    data = JSON.parse json_string, symbolize_names: true
    attributes = {
      id: data[:id],
      email: data[:email],
      extra_fields: data[:extra_fields].with_indifferent_access,
      first_name: data[:first_name],
      last_name: data[:last_name],
      locale: data[:locale],
      name: data[:name],
      roles: data[:roles],
      created_at: DateTime.parse(data[:created_at]),
      updated_at: DateTime.parse(data[:updated_at])
    }

    attributes
  end
end
