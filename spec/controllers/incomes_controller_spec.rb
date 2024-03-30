require 'rails_helper'

RSpec.describe IncomesController, type: :controller do
  let(:user) { create(:user) }
  let(:income) { create(:income, user:) }
  let(:other_user) { create(:user) }
  let(:valid_attributes) do
    { amount: 1000, source: 'Salary', date: Date.today }
  end
  let(:invalid_attributes) do
    { amount: nil, source: '', date: nil }
  end

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
      get :show, params: { user_id: user.id, id: income.id }
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
      it '新しい収入を追加する' do
        expect do
          post :create, params: { user_id: user.id, income: valid_attributes }
        end.to change(Income, :count).by(1)
      end
    end

    context '無効なパラメータの場合' do
      it '収入を追加しない' do
        expect do
          post :create, params: { user_id: user.id, income: invalid_attributes }
        end.not_to change(Income, :count)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    context '有効なパラメータの場合' do
      it '収入を更新する' do
        patch :update, params: { user_id: user.id, id: income.id, income: { amount: 200 } }
        income.reload
        expect(income.amount).to eq(200)
      end
    end

    context '無効なパラメータの場合' do
      it '収入を更新しない' do
        original_amount = income.amount
        patch :update, params: { user_id: user.id, id: income.id, income: invalid_attributes }
        income.reload
        expect(income.amount).to eq(original_amount)
        expect(response).to render_template(:edit)
      end

      it '他のユーザーの支出は更新しない' do
        sign_in other_user # 別のユーザーでサインイン
        original_amount = income.amount
        patch :update, params: { user_id: user.id, id: income.id, income: invalid_attributes }
        income.reload
        expect(income.amount).to eq(original_amount)
        expect(response).to redirect_to(root_path) # 権限がないためリダイレクトされることを期待
      end
    end
  end

  describe 'DELETE #destroy' do
    it '収入を削除する' do
      income_to_delete = create(:income, user:)
      expect do
        delete :destroy, params: { user_id: user.id, id: income_to_delete.id }
      end.to change(Income, :count).by(-1)
    end
  end
end
