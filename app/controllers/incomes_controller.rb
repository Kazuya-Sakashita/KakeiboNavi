class IncomesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :set_income, only: [:show, :edit, :update, :destroy]

  def index
    @incomes = current_user.incomes.order(:date)
    @bar_data = @incomes.group_by(&:date).transform_values do |incomes|
      incomes.sum(&:amount)
    end

    @bar_data_par_month = @incomes.group_by { |income| income.date.strftime("%Y-%m") }.transform_values do |incomes|
      incomes.sum(&:amount)
    end
  end

  def show
  end

  def new
    @income = @user.incomes.new
  end

  def edit
  end

  def create
    @income = @user.incomes.new(income_params)

    if @income.save
      flash[:notice] = '収入を記録しました。'
      redirect_to user_incomes_path(@user)
    else
      flash.now[:alert] = @income.errors.full_messages.to_sentence
      render :new
    end
  end


  def update
    @income = Income.find(params[:id])

    if @income.update(income_params)
      flash[:success] = '収入情報を更新しました。'
      redirect_to user_income_path(@user, @income)
    else
      flash.now[:error] = @income.errors.full_messages.join(', ')
      render :edit
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
end
