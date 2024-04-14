# frozen_string_literal: true

class Expense < ApplicationRecord
  belongs_to :user

  # 複数の属性に対する presence バリデーションを一つにまとめる
  validates :amount, :description, :date, presence: true

  # amount が数値であること、および特定の範囲内であることを確認（範囲は例として設定）
  validates :amount,
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1_000_000,
                            message: 'は0から1,000,000の間である必要があります' }

  # Ransackによる検索可能な属性を指定
  def self.ransackable_attributes(auth_object = nil)
    # `super`を使用してデフォルトの属性を取得し、検索に含めたい属性を追加する
    super + %w[id amount description date]
  end

  # Ransackによる検索可能な関連付けを指定
  def self.ransackable_associations(_auth_object = nil)
    # ここで検索に使用する関連付けの名前を配列として返す
    # 例: ['user', 'category']
    %w[user category]
  end

  # 年度に基づくカスタム検索定義
  ransacker :fiscal_year do
    Arel.sql('YEAR(date)')
  end
end
