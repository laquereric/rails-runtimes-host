# frozen_string_literal: true

Rails.application.config.filter_parameters += %i[
  passw email secret token _key crypt salt certificate otp ssn sync_token registration_code
]
