require "ffaker"

Fabricator(:user) do
  books(count: 10)
  votes(count: 5)
  email { FFaker::Internet.safe_email }
  password {"nickpass"}
  password_confirmation {"nickpass"}
  full_address {FFaker::AddressFR.full_address }
  range {FFaker::Number.between(10000,50000)}
  full_address { FFaker::AddressFR.full_address }
end