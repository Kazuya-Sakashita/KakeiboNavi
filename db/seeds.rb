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


5.times do |user_index|
  user = User.create!(
    email: "user#{user_index + 1}@example.com",
    password: 'password',
    password_confirmation: 'password'
  )

  4.times do |year| # 4年分のデータ、2020年から開始
    12.times do |month|
      # 月に3回の収入データを生成
      3.times do |i|
        Income.create!(
          user_id: user.id,
          amount: rand(20000..50000),  # 収入範囲を調整
          source: "収入源#{user_index * 100 + year * 10 + i + 1}",
          date: Date.new(2020 + year, month + 1, rand(1..28))
        )
      end

      # 月に10回の支出データを生成
      10.times do |j|
        Expense.create!(
          user_id: user.id,
          amount: rand(500..10000),  # 支出範囲を調整
          description: "支出#{user_index * 100 + year * 10 + j + 1}",
          date: Date.new(2020 + year, month + 1, rand(1..28))
        )
      end
    end
  end
end
