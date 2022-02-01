class Restaurant < ApplicationRecord
  # Restaurantモデルから見てFoodモデルとLineFoodモデルはhas_many関係、複数形で書く
  has_many :foods
  has_many :line_foods,through: :foods

  # name,fee,time_requiredはカラムにデータが存在しないとエラーになることを定義
  validates :name,:fee,:time_required,presence:true
  # 名前が30文字までを制限
  validates :name, length:{maximum:30}
  # 手数料が0以上であるように制限している
  validates :fee, numericality: {greater_than:0}
end