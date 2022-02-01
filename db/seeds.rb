
# ここで3回Restaurant.new()させています。Restaurantクラスからrestaurantインスタンスを作成しています。
# また、それぞれのnameはユニークなものにしたいので、"testレストラン_0", "testレストラン_1"...となるようにします。
# feeやtime_requiredは固定の値を設定します。
3.times do |n|
  restaurant = Restaurant.new(
    name: "testレストラン_#{n}",
    fee: 100,
    time_required: 10,
  )
  # さらにそれぞれのrestaurantに１つにつき12個のfoodを作成します。
  # restaurant.foods.buildとすることで、Food.newすることなくリレーションを持ったfoodを生成することができます。
  # nameとdescriptionもそれぞれユニークなものを設定します。
  12.times do |m|
    restaurant.foods.build(
      name: "food名_#{m}",
      price:500,
      description: "food_#{m}の説明文です"
    )
  end
  # 最後に生成したrestaurantインスタンスをsave!することで、データをDBに書き込むことができます。
  restaurant.save!
end