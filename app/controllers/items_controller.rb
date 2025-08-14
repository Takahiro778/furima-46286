# app/controllers/items_controller.rb
class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @items = Item.order(created_at: :desc)
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path, notice: '商品を出品しました。'
    else
      flash.now[:alert] = '入力内容を確認してください。'
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  private

  # README準拠のカラム＋画像（ActiveStorage）
  def item_params
    params.require(:item).permit(
      :name, :info, :category_id, :sales_status_id, :shipping_fee_status_id,
      :prefecture_id, :scheduled_delivery_id, :price, :image
    ).merge(user_id: current_user.id)
  end
end
