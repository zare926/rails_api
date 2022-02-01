module Api
  module V1
    class LineFoodsController < ApplicationController
      # railsではアクションの実行前にフィルタとしてbefore_action :フィルタアクション名を定義できます。
      # こうすることで、今回の例で言えばcreateの実行前に、set_foodを実行することができます。
      # また、:onlyオプションをつけることで、特定のアクションの実行前にだけ追加するということができます。
      before_action :set_food,only:%i[create replace]


      def index
        # models/line_food.rbのscope :activeですね。
        # モデル名.スコープ名というかたちです。
        # これで、active: trueなLineFoodの一覧がActiveRecord_Relationのかたちで取得できます。
        line_foods = LineFood.active
        # .exists?メソッドは対象のインスタンスのデータがDBに存在するかどうか？をtrue/falseで返すメソッドです。
        if line_foods.exist?
          render json:{
            line_food_ids: line_foods.map{|line_food| line_food.id},
            restaurant: line_foods[0].restaurant,
            count: line_foods.sum {|line_food| line_food[:count]},
            amount: line_foods.sum {|line_food| line_food.total_amount},
          },status: :ok
        else
          render json:{}.status: :no_content
        end
      end

      def created
        if LineFood.active.other_restaurant(@ordered_food.restaurant.id).exist?
          return render json:{ 
            existing_restaurant:LinkeFood.other_restaurant(@ordered_food.restaurant.id).first.restaurant.name,
            new_restaurant: Food.find(params[:food_id]).restaurant.name,
          },status: :not_acceptable
        end
      

        set_line_food(@ordered_food)

        # @line_foodをsaveで保存します。
        # この時にエラーが発生した場合にはif @line_food.saveでfalseと判断されrender json: {}, status: :internal_server_errorが返ります。
        # もしフロントエンドでエラーの内容に応じて表示を変えるような場合にここでHTTPレスポンスステータスコードが500系になることをチェックできます。
        if @line_food.save
          render json:{ 
            line_food: @line_food
          },status: :created
        else
          # 今回は一つも存在しない場合はエラーを返すのではなく、空データとstatus: :no_contentを返すことにします。
          render json:{},status: :internal_server_error
        end
      end

      def replace
        LineFood.active.other_restaurant(@ordered_food.restaurant.id).each do |line_food|
          line_food.update_attribute(:active,false)
        end

        set_line_food(@ordered_food)

        if @line_food.save
          render json:{
            line_food: @line_food
          },status: :created
        else
          render json:{},status: :internal_server_error
        end
      end

      private
      # set_foodはこのコントローラーの中でしか呼ばれないアクションです。そのため、privateにします。
      def set_food
        @ordered_food = Food.find(params[:food_id])
      end

      def set_line_food(ordered_food)
        if ordered_food.line_food.present?
          @line_food = ordered_food.line_food
          @line_food.attributes = { 
            count: ordered_food.line_food.count + params[:count]
            active: true
          }
        else
          @line_food = ordered_food.bulid_line_food(
            count: params[:count],
            restaurant: ordered_food.restaurant,
            active:true
          )
        end
      end
    end
  end
end