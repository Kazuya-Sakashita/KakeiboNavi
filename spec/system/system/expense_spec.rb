require 'rails_helper'

RSpec.describe '支出管理', type: :system, js: true do
  let(:user) { create(:user) }
  let(:expense) { create(:expense, user:) }

  before do
    driven_by :selenium_chrome_headless
    sign_in user
  end

  describe '新しい支出の追加' do
    it 'ユーザーが新しい支出を追加できること' do
      visit new_user_expense_path(user)

      fill_in '金額', with: 5000
      fill_in '使用目的(項目)', with: '外食'
      fill_in '日付', with: '002023-01-01'
      click_on '支出を登録'

      expect(page).to have_content '支出情報を追加しました。'
      expect(page).to have_content '5000.0'
      expect(page).to have_content '外食'
    end
  end

  describe '支出の表示' do
    it '支出が表示されること' do
      create(:expense, user:, amount: 3000, description: '食料品', date: '2023-01-02')
      visit user_expenses_path(user)

      expect(page).to have_content '3000'
      expect(page).to have_content '食料品'
    end
  end

  describe '支出の編集' do
    let!(:expense) { create(:expense, user:) }

    it 'ユーザーが支出を編集できること' do
      visit edit_user_expense_path(user, expense)

      fill_in '金額', with: 4500
      click_on '支出を更新'

      expect(page).to have_content '支出情報を更新しました。'
      expect(page).to have_content '4500'
    end
  end

  describe '支出の削除', type: :system, js: true do
    let!(:expense) { create(:expense, user:) }

    it 'ユーザーが支出を削除できること' do
      visit user_expenses_path(user)
      expect(page).to have_content expense.amount

      accept_confirm do
        find_link('削除', href: user_expense_path(user, expense)).click
      end

      expect(page).to have_content '支出を削除しました。'
      expect(page).not_to have_content expense.amount
    end
  end
end
