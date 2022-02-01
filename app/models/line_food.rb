class LineFood < ApplicationRecord
  belongs_to :food
  belongs_to :restaurant
  belongs_to :order,optional:true

  validates :count,numericality:{greater_than:0}

  # LineFoodのactiveなものを一覧で取得してくれる書き方
  # 使い方→LineFood.active
  scope :active, -> {where(active: true)}
  # 他の店舗のlineFoodがあるかどうかを判定
  scope :other_restaurant,->(picked_restaurant_id){where.not(restaurant_id: picked_restaurant_id)}
  
  # インスタンスメソッド
  def total_amount
    food.price * count
  end
end