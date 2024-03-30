# frozen_string_literal: true

# spec/factories/incomes.rb

FactoryBot.define do
  factory :income do
    association :user

    amount { Faker::Number.number(digits: 6) } # 6桁の数値を生成
    source { Faker::Company.name } # 会社名を収入源として利用
    date { Faker::Date.between(from: 2.years.ago, to: Time.zone.today) } # 過去2年間のランダムな日付
  end
end
