class ItemsController < ApplicationController
  # 一覧・詳細は非ログインでも閲覧可
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_item, only: [:show, :edit, :update]
  before_action :redirect_unless_owner, only: [:edit, :update]

  def index
    # 新着順 + 画像のN+1回避
    @items = Item.includes(image_attachment: :blob).order(created_at: :desc)
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # 表示専用（ロジックは持たない）
  end

  def edit
    # set_item が読み込むので空でOK
  end

  def update
    if @item.update(item_params)
      redirect_to item_path(@item), notice: "商品情報を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_item
    # 画像を事前読込しておく（ActiveStorageのN+1回避 & 画像表示の安定化）
    @item = Item.with_attached_image.find(params[:id])
  end

  def redirect_unless_owner
    redirect_to root_path, alert: "権限がありません" unless current_user == @item.user
  end

  def item_params
    params.require(:item).permit(
      :image, :name, :info, :category_id, :sales_status_id,
      :shipping_fee_status_id, :prefecture_id, :scheduled_delivery_id, :price
    ).merge(user_id: current_user.id)
  end
end
