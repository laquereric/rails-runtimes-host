# frozen_string_literal: true

email = ENV.fetch("HOST_ADMIN_EMAIL", "admin@example.test")
password = ENV.fetch("HOST_ADMIN_PASSWORD", "change-me-for-local-demo")

admin = User.find_or_initialize_by(email_downcase: email.downcase)
admin.email = email
admin.display_name = "Host Admin"
admin.role = "admin"
admin.password = password
admin.save!

puts "Seeded admin #{admin.email}"
