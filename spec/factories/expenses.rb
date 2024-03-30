# frozen_string_literal: true

FactoryBot.define do
  factory :expense do
    association :user

    amount { Faker::Number.number(digits: 5) } # 5桁の数値を生成
    description { Faker::Commerce.department } # 購入元の部門名
    date { Faker::Date.between(from: 2.years.ago, to: Time.zone.today) } # 過去2年間のランダムな日付

    # モデルに他の属性がある場合は、ここに追加してください
  end
end
