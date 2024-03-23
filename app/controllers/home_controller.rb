class HomeController < ApplicationController
  def index
    # ダミーデータの生成
    @line_chart_data = { '2023-01-01' => 5, '2023-01-02' => 3, '2023-01-03' => 6 }
    @pie_chart_data = { 'Apple' => 10, 'Banana' => 5, 'Grape' => 7 }
    @bar_chart_data = { '2023-01-01' => 3, '2023-01-02' => 7, '2023-01-03' => 5 }
    @column_chart_data = { '2023-01-01' => 2, '2023-01-02' => 4, '2023-01-03' => 1 }
  end
end
