# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpensesController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:valid_attributes) do
    { amount: 1000, description: 'Food', date: Time.zone.today }
  end
  let(:invalid_attributes) do
    { amount: nil, description: '', date: nil }
  end
  let(:expense) { create(:expense, user:) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it '正常に応答する' do
      get :index, params: { user_id: user.id }
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it '正常に応答する' do
      get :show, params: { user_id: user.id, id: expense.id }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it '正常に応答する' do
      get :new, params: { user_id: user.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context '有効なパラメータの場合' do
      it '新しい支出を追加する' do
        expect do
          post :create, params: { user_id: user.id, expense: valid_attributes }
        end.to change(Expense, :count).by(1)
      end
    end

    context '無効なパラメータの場合' do
      it '支出を追加しない' do
        expect do
          post :create, params: { user_id: user.id, expense: invalid_attributes }
        end.not_to change(Expense, :count)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    context '有効なパラメータの場合' do
      it '支出を更新する' do
        patch :update, params: { user_id: user.id, id: expense.id, expense: { amount: 500 } }
        expense.reload
        expect(expense.amount).to eq(500)
      end
    end

    context '無効なパラメータの場合' do
      it '支出を更新しない' do
        original_amount = expense.amount
        patch :update, params: { user_id: user.id, id: expense.id, expense: invalid_attributes }
        expense.reload
        expect(expense.amount).to eq(original_amount)
        expect(response).to render_template(:edit)
      end

      it '他のユーザーの支出は更新しない' do
        sign_in other_user # 別のユーザーでサインイン
        original_amount = expense.amount
        patch :update, params: { user_id: user.id, id: expense.id, expense: invalid_attributes }
        expense.reload
        expect(expense.amount).to eq(original_amount)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    it '支出を削除する' do
      expense_to_delete = create(:expense, user:)
      expect do
        delete :destroy, params: { user_id: user.id, id: expense_to_delete.id }
      end.to change(Expense, :count).by(-1)
    end
  end
end
