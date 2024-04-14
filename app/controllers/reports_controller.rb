class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def index
    # `@q`をRansack::Searchオブジェクトとして初期化
    @q = current_user.expenses.ransack(params[:q])
    @expenses = @q.result(distinct: true)

    set_fiscal_year_range if params[:q]&.dig(:fiscal_year).present?

    # @expenses = @q_expenses.result(distinct: true)
    # @incomes =  @q_incomes.result(distinct: true)

    # 年度に基づいてデータをフィルタリング
    filtered_incomes = current_user.incomes
    filtered_expenses = current_user.expenses

    @data_par_month = (filtered_incomes + filtered_expenses)
      .group_by { |record| record.date.strftime('%Y-%m') }
      .transform_values do |records|
      {
        income: records.filter { |record| record.is_a?(Income) }.sum(&:amount),
        expense: records.filter { |record| record.is_a?(Expense) }.sum(&:amount)
      }
    end

    @incomes_data_par_monthpar_month = filtered_incomes.group_by { |income| income.date.strftime('%Y-%m') }.transform_values do |incomes|
      incomes.sum(&:amount)
    end

    @expenses_par_month = filtered_expenses.group_by { |expense| expense.date.strftime('%Y-%m') }.transform_values do |expenses|
      expenses.sum(&:amount)
    end
  end

  def show; end

  private

  def set_user
    @user = current_user
  end

  def search_params
    params[:q]&.permit(:description_cont, :amount_gteq, :amount_lteq, :date_gteq, :date_lteq, :fiscal_year)
  end

  def set_fiscal_year_range
    year = params[:q][:fiscal_year].to_i
    @start_date = Date.new(year, 4, 1)
    @end_date = Date.new(year + 1, 3, 31)
    @q.date_gteq = @start_date
    @q.date_lteq = @end_date
  end
end
