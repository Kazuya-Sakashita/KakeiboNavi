# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Expense, type: :model do
  let(:user) { create(:user) }

  describe 'バリデーション' do
    it 'すべての属性が有効な場合、支出は有効である' do
      expense = build(:expense, user:, amount: 500, description: '食事', date: Time.zone.today)
      expect(expense).to be_valid
    end

    it 'amountが空の場合、支出は無効である' do
      expense = build(:expense, user:, amount: nil, description: '食事', date: Time.zone.today)
      expect(expense).not_to be_valid
    end

    it 'descriptionが空の場合、支出は無効である' do
      expense = build(:expense, user:, amount: 500, description: nil, date: Time.zone.today)
      expect(expense).not_to be_valid
    end

    it 'dateが空の場合、支出は無効である' do
      expense = build(:expense, user:, amount: 500, description: '食事', date: nil)
      expect(expense).not_to be_valid
    end

    it 'amountが0未満の場合、支出は無効である' do
      expense = build(:expense, user:, amount: -1, description: '食事', date: Time.zone.today)
      expect(expense).not_to be_valid
    end

    it 'amountが1000000を超える場合、支出は無効である' do
      expense = build(:expense, user:, amount: 1_000_001, description: '食事', date: Time.zone.today)
      expect(expense).not_to be_valid
    end

    it 'amountが範囲内（0以上1000000以下）の場合、支出は有効である' do
      expense = build(:expense, user:, amount: 1_000_000, description: '食事', date: Time.zone.today)
      expect(expense).to be_valid
    end
  end
end
