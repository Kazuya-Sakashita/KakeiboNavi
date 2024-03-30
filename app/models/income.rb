# frozen_string_literal: true

class Income < ApplicationRecord
  belongs_to :user

  validates :user_id, numericality: { only_integer: true }
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :source, presence: true, length: { maximum: 100 }
  validates :date, presence: true

  validate :date_cannot_be_in_the_future

  private

  def date_cannot_be_in_the_future
    errors.add(:date, 'は未来の日付であってはいけません') if date.present? && date > Time.zone.today
  end
end
