class ExpensesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :set_expense, only: %i[show edit update destroy]

  def index
    @expenses = current_user.expenses.order(:date)
  end

  def show; end

  def new
    @expense = @user.expenses.new
  end

  def edit; end

  def create
    @expense = @user.expenses.new(expense_params)
    if @expense.save
      handle_success('支出を記録しました。')
    else
      handle_failure(:new)
    end
  end

  def update
    if @expense.update(expense_params)
      handle_success('支出情報を更新しました。')
    else
      handle_failure(:edit)
    end
  end

  def destroy
    @expense.destroy
    redirect_to user_expenses_path(@user), notice: '支出を削除しました。'
  end

  private

  def set_expense
    @expense = @user.expenses.find_by(id: params[:id])
    redirect_to root_path, alert: '不正なアクセスです。' if @expense.nil?
  end

  def expense_params
    params.require(:expense).permit(:user_id, :amount, :description, :date)
  end

  def set_user
    @user = current_user
  end

  def handle_success(notice_message)
    redirect_to user_expenses_path(@user), notice: notice_message
  end

  def handle_failure(template)
    flash.now[:alert] = @expense.errors.full_messages.to_sentence
    render template, status: :unprocessable_entity
  end
end
