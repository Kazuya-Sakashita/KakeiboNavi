# frozen_string_literal: true

class IncomesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :set_income, only: %i[show edit update destroy]

  def index
    @incomes = current_user.incomes.order(:date)
    @bar_data = @incomes.group_by(&:date).transform_values do |incomes|
      incomes.sum(&:amount)
    end

    @incomes_par_month = @incomes.group_by { |income| income.date.strftime('%Y-%m') }.transform_values do |incomes|
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
      handle_success('収入情報を追加しました。')
    else
      handle_failure
    end
  end

  def update
    @income = Income.find(params[:id])
    if @income.update(income_params)
      handle_success('収入情報を更新しました。')
    else
      handle_update_failure
    end
  end

  def destroy
    @income.destroy
    redirect_to user_incomes_path(@user), notice: '収入を削除しました。'
  end

  private

  def set_income
    @income = @user.incomes.find_by(id: params[:id])
    redirect_to root_path, alert: '不正なアクセスです。' if @income.nil?
  end

  def income_params
    params.require(:income).permit(:user_id, :amount, :source, :date)
  end

  def set_user
    @user = current_user
  end

  def handle_success(notice_message)
    redirect_to user_incomes_path(@user), notice: notice_message
  end

  def handle_failure
    flash.now[:alert] = @income.errors.full_messages.to_sentence
    render :new, status: :unprocessable_entity
  end

  def handle_update_failure
    flash.now[:alert] = @income.errors.full_messages.to_sentence
    render :edit, status: :unprocessable_entity
  end
end
