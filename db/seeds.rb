# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

3.times do |i|
  user = User.create!(
    email: "user#{i + 1}@example.com",
    password: 'password',
    password_confirmation: 'password'
  )

  12.times do |j|
    Income.create!(
      user_id: user.id,
      amount: rand(1000..5000), # 仮に1000から5000の範囲でランダムに金額を設定
      source: "収入源#{j + 1}",
      date: Date.new(2023, j + 1, 1) # 2023年の各月を示す
    )
  end
end
