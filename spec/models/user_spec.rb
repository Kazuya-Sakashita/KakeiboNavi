# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'メールアドレスのバリデーション' do
    it 'メールアドレスとパスワードがあれば有効である' do
      user = User.new(email: 'alice@example.com', password: 'password')
      expect(user).to be_valid
    end

    it 'メールアドレスがなければ無効である' do
      user = User.new(email: nil, password: 'password')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('を入力してください')
    end

    it '重複したメールアドレスなら無効である' do
      User.create(email: 'bob@example.com', password: 'password')
      user = User.new(email: 'bob@example.com', password: 'password')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('はすでに存在します')
    end
  end

  # 他のバリデーションやメソッドのテストをここに追加する
end
