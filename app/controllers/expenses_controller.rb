class ExpensesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  # before_action :set_expense, only: [:show, :edit, :update, :destroy]



  def index
    @expenses = current_user.expenses
  end

  def new
    @expense = @user.expenses.new
  end

  def create
    @expense = @user.expenses.new(expense_params)

    respond_to do |format|
      if @expense.save
        format.html { redirect_to user_expenses_path(@user), notice: '支出を記録しました。' }
        format.turbo_stream { redirect_to user_expenses_path(@user), notice: '支出を記録しました。' }
      else
        format.html { flash.now[:alert] = @expense.errors.full_messages.to_sentence; render :new, status: :unprocessable_entity }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("form_errors", partial: "expenses/form_errors", locals: { expense: @expense }) }
      end
    end
  end

  def show
    @expense = Expense.find(params[:id])
  end

  def edit
    @expense = Expense.find(params[:id])
  end

  def update
    @expense = Expense.find(params[:id])

    respond_to do |format|
      if @expense.update(expense_params)
        format.html { redirect_to user_expenses_path(@user), notice: '支出情報を更新しました。' }
        format.turbo_stream { redirect_to user_expenses_path(@user), notice: '支出情報を更新しました。' }
      else
        format.html { flash.now[:alert] = @expense.errors.full_messages.to_sentence; render :new, status: :unprocessable_entity }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("form_errors", partial: "expenses/form_errors", locals: { expense: @expense }) }
      end
    end
  end

  def destroy
    @expense = Expense.find(params[:id])
    @expense.destroy
    redirect_to user_expenses_path(@user), notice: 'Income was successfully destroyed.'
  end

  private
  def set_expense
    @expense = Expense.find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(:user_id, :amount, :description, :date)
  end

  def set_user
    @user = current_user
  end
end
