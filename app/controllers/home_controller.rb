class HomeController < ApplicationController
  def index
    # ダミーデータの生成
    @line_data = { "2020-01-01": 10, "2020-01-02": 15, "2020-01-03": 20 }
    @bar_data = { "Apple": 50, "Orange": 70, "Banana": 85 }
    @pie_data = { "Water": 30, "Fire": 70 }
  end
end
