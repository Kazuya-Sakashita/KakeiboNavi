# frozen_string_literal: true

class Income < ApplicationRecord
  belongs_to :user

  # 仮想属性を追加
  attr_accessor :fiscal_year

  validates :user_id, numericality: { only_integer: true }
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :source, presence: true, length: { maximum: 100 }
  validates :date, presence: true

  validate :date_cannot_be_in_the_future

  def self.ransackable_attributes(auth_object = nil)
    super + ["fiscal_year"] # 仮想属性を検索可能な属性に追加
  end

  def self.ransackable_associations(_auth_object = nil)
    ["user"]
  end

  private

  def date_cannot_be_in_the_future
    errors.add(:date, 'は未来の日付であってはいけません') if date.present? && date > Time.zone.today
  end

  # 年度を計算するメソッド
  def calculate_fiscal_year
    return nil unless date

    year = date.month >= 4 ? date.year : date.year - 1
    self.fiscal_year = year
  end

  # 年度計算のためにレコードがロードされた際に実行
  after_find :calculate_fiscal_year
end
