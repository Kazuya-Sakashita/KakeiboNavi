require 'rails_helper'

RSpec.describe '収入管理', type: :system do
  let(:user) { create(:user) }
  let(:income) { create(:income, user:) }

  before do
    driven_by(:selenium_chrome_headless) # ヘッドレスモードでChromeを使用
    sign_in user
  end

  describe '収入の登録' do
    it 'ユーザーが新しい収入を登録できる' do
      visit new_user_income_path(user)

      fill_in '金額', with: 5000
      fill_in '収入源', with: 'フリーランス' # フォームのラベルまたはフィールド名に合わせて修正
      fill_in '日付', with: '002023-01-01' # フォームのラベルまたはフィールド名に合わせて修正
      click_button '収入を登録'

      expect(page).to have_content '収入情報を追加しました。'
      expect(page).to have_content '5000.0' # フォーマットや表示方法によって調整が必要かもしれません
      expect(page).to have_content 'フリーランス'
    end
  end

  describe '収入の表示' do
    it 'ユーザーが収入の詳細を表示できる' do
      visit user_income_path(user, income)
      expect(page).to have_content income.amount
      expect(page).to have_content income.source
    end
  end

  describe '収入の編集' do
    it 'ユーザーが収入を編集できる' do
      visit edit_user_income_path(user, income)
      fill_in '金額', with: 6000
      click_button '更新'

      expect(page).to have_content '収入情報を更新しました。'
      expect(page).to have_content '6000'
    end
  end

  describe '収入の削除' do
    it 'ユーザーが収入を削除できる' do
      visit user_income_path(user, income)
      accept_confirm do
        click_link '削除', href: user_income_path(user, income)
      end

      expect(page).to have_content '収入を削除しました。'
      # expect(page).not_to have_content income.amount
    end
  end
end
