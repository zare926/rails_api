class Food < ApplicationRecord
  # RestaurantモデルとOrderモデルはbelongs_toの関係
  belongs_to :restaurant
  # optional: tureは関連付けが任意で良くなる、存在しなくてもエラーにならない
  belongs_to :order,optional: true
  # LineFoodモデルとは１:1の関係なのでhas_oneを定義
  has_one :line_food
end