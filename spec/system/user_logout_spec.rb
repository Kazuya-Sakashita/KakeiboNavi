# spec/system/user_logout_spec.rb
require 'rails_helper'

RSpec.describe 'ユーザーログアウト', type: :system do
  before do
    driven_by(:selenium_chrome_headless)
    user = FactoryBot.create(:user)
    login_as(user, scope: :user)
    visit root_path
  end

  it 'ユーザーがログアウトできること' do
    accept_confirm do
      click_link 'ログアウト'
    end

    expect(page).to have_content 'ログイン'
  end
end
