class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :authorize_item_owner!, only: [:edit, :update, :destroy]

  def index
    @items = Item.includes(image_attachment: :blob).order(created_at: :desc)
  end

  def show
  end

  def new
    @item = Item.new
  end

  def edit
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path, notice: '商品を出品しました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @item.update(item_params)
      redirect_to @item, notice: '商品情報を更新しました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    redirect_to root_path, notice: '商品を削除しました。'
  end

  private

  def set_item
    @item = Item.with_attached_image.find(params[:id])
  end

  def authorize_item_owner!
    redirect_to root_path, alert: '権限がありません。' unless current_user == @item.user
  end

  def item_params
    params.require(:item).permit(
      :image, :name, :info, :category_id, :sales_status_id,
      :shipping_fee_status_id, :prefecture_id, :scheduled_delivery_id, :price
    ).merge(user_id: current_user.id)
  end
end
