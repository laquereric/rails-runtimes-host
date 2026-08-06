# frozen_string_literal: true
# Copyright 2026 CBI BUSINESS TRANSACTIONS, LLC
# SPDX-License-Identifier: Apache-2.0
# Part of RailsRuntimes -- https://github.com/laquereric/DataYoursSoftwareMine

require "digest"
require "securerandom"

module PublicTodoHost
  module Server
    module Token
      module_function

      def generate
        SecureRandom.urlsafe_base64(32)
      end

      def digest(raw)
        Digest::SHA256.hexdigest(raw.to_s)
      end

      def matches?(raw, digest_value)
        digest(raw) == digest_value.to_s
      end
    end
  end
end
