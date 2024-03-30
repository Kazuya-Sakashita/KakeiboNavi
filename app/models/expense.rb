# frozen_string_literal: true

class Expense < ApplicationRecord
  belongs_to :user

  # 複数の属性に対する presence バリデーションを一つにまとめる
  validates :amount, :description, :date, presence: true

  # amount が数値であること、および特定の範囲内であることを確認（範囲は例として設定）
  validates :amount,
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1_000_000,
                            message: 'は0から1,000,000の間である必要があります' }
end
