class ItemsController < ApplicationController
  before_action :set_item, only: %i[show edit update destroy]
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :redirect_if_forbidden, only: %i[edit update destroy]

  # これを追加
  def index
    # 画像と注文を先読みしてN+1回避
    @items = Item.with_attached_image.includes(:order).order(created_at: :desc)
  end

  def show; end
  def new;  @item = Item.new; end
  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path, notice: t('items.created', default: '商品を出品しました。')
    else
      render :new, status: :unprocessable_entity
    end
  end
  def edit; end
  def update
    if @item.update(item_params)
      redirect_to @item, notice: t('items.updated', default: '商品情報を更新しました。')
    else
      render :edit, status: :unprocessable_entity
    end
  end
  def destroy
    @item.destroy
    redirect_to root_path, notice: t('items.destroyed', default: '商品を削除しました。')
  end

  private
  def set_item
    @item = Item.find(params[:id])
  end

  # 出品者以外 or 売却済み は編集系を禁止
  def redirect_if_forbidden
    if @item.order.present? || current_user != @item.user
      redirect_to root_path, alert: t('items.forbidden', default: '権限がありません。')
    end
  end

  def item_params
    params.require(:item).permit(
      :name, :info, :price, :image,
      :category_id, :sales_status_id, :shipping_fee_status_id,
      :prefecture_id, :scheduled_delivery_id
    ).merge(user_id: current_user.id)
  end
end
