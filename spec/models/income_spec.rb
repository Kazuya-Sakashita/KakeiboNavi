require 'rails_helper'

RSpec.describe Income, type: :model do
  let(:user) { create(:user) }

  describe 'バリデーション' do
    it '有効な属性値の場合、収入は有効である' do
      income = build(:income, user:, date: Time.zone.today)
      expect(income).to be_valid
    end

    it 'user_idがnilの場合、収入は無効である' do
      income = build(:income, user: nil, date: Time.zone.today)
      expect(income).not_to be_valid
    end

    it 'amountが0以下の場合、収入は無効である' do
      income = build(:income, user:, amount: 0, date: Time.zone.today)
      expect(income).not_to be_valid
    end

    it 'sourceが空の場合、収入は無効である' do
      income = build(:income, user:, source: '', date: Time.zone.today)
      expect(income).not_to be_valid
    end

    it 'sourceが101文字以上の場合、収入は無効である' do
      income = build(:income, user:, source: 'a' * 101, date: Time.zone.today)
      expect(income).not_to be_valid
    end

    it 'dateが未来の日付の場合、収入は無効である' do
      income = build(:income, user:, date: Time.zone.tomorrow)
      expect(income).not_to be_valid
    end

    it 'dateが現在の日付の場合、収入は有効である' do
      income = build(:income, user:, date: Time.zone.today)
      expect(income).to be_valid
    end

    it 'dateが過去の日付の場合、収入は有効である' do
      income = build(:income, user:, date: Time.zone.yesterday)
      expect(income).to be_valid
    end
  end
end
