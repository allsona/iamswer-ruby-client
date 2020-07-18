module Iamswer::Meta::Fields
  # representing user-assignable fields (not treated as extra fields)
  NATIVE_ASSIGNABLES = [
    EMAIL = "email".freeze,
    FIRST_NAME = "first_name".freeze,
    LAST_NAME = "last_name".freeze,
    NAME = "name".freeze,
    USERNAME = "username".freeze,
    PASSWORD = "password".freeze,
    LOCALE = "locale".freeze
  ].freeze

  MULTIPART_NAME_FIELDS = [
    FIRST_NAME,
    LAST_NAME,
  ].freeze
end
