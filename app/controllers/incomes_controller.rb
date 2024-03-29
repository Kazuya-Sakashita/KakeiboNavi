# frozen_string_literal: true

# 収入に関連する操作を扱うコントローラ
class IncomesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :set_income, only: %i[show edit update destroy]

  def index
    @incomes = current_user.incomes.order(:date)
    @bar_data = @incomes.group_by(&:date).transform_values do |incomes|
      incomes.sum(&:amount)
    end

    @bar_data_par_month = @incomes.group_by { |income| income.date.strftime('%Y-%m') }.transform_values do |incomes|
      incomes.sum(&:amount)
    end
  end

  def show; end

  def new
    @income = @user.incomes.new
  end

  def edit; end

  def create
    @income = @user.incomes.new(income_params)
    if @income.save
      handle_success
    else
      handle_failure
    end
  end

  def update
    @income = Income.find(params[:id])

    if @income.update(income_params)
      handle_update_success
    else
      handle_update_failure
    end
  end

  def destroy
    @income.destroy
    redirect_to user_incomes_path, notice: 'Income was successfully destroyed.'
  end

  private

  def set_income
    @income = Income.find(params[:id])
  end

  def income_params
    params.require(:income).permit(:user_id, :amount, :source, :date)
  end

  def set_user
    @user = current_user
  end

  def handle_successs
    respond_to do |format|
      format.html { redirect_to_success }
      format.turbo_stream { redirect_to_success }
    end
  end

  def handle_failure
    respond_to do |format|
      format.html { render_failure_html }
      format.turbo_stream { render_failure_turbo_stream }
    end
  end

  def redirect_to_success(notice_message)
    redirect_to user_incomes_path(@user), notice: notice_message
  end

  def render_failure_html
    flash.now[:alert] = @income.errors.full_messages.to_sentence
    render :new, status: :unprocessable_entity
  end

  def render_failure_turbo_stream
    render turbo_stream: turbo_stream.replace('form_errors', partial: 'incomes/form_errors',
                                                             locals: { income: @income })
  end

  def handle_update_success
    respond_to do |format|
      format.html { redirect_to_success('収入情報を更新しました。') }
      format.turbo_stream { redirect_to_success('収入情報を更新しました。') }
    end
  end

  def handle_update_failure
    respond_to do |format|
      format.html { render_failure_html }
      format.turbo_stream { render_failure_turbo_stream }
    end
  end
end
