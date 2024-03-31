# spec/system/user_login_spec.rb

require 'rails_helper'

RSpec.describe 'ユーザーログイン', type: :system do
  let(:user) { create(:user, email: 'user@example.com', password: 'password') }

  before do
    driven_by(:rack_test)
  end

  it 'ユーザーがログインでき、ダッシュボードにリダイレクトされること' do
    # ログインページにアクセス
    visit '/users/sign_in'

    # メールアドレスとパスワードを入力
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'password'

    # ログインボタンをクリック
    click_button 'Log in'

    # ダッシュボードが表示されていることを確認
    expect(current_path).to eq(root_path) # リダイレクト先がroot_pathであることを検証
    expect(page).to have_content 'ログインしました' # ログイン成功のメッセージが表示されているかを検証
  end
end
