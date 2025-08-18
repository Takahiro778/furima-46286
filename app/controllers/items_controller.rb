class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_item, only: [:show, :edit, :update]
  before_action :redirect_unless_owner!, only: [:edit, :update]

  def index
    @items = Item.includes(image_attachment: :blob).order(created_at: :desc)
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to item_path(@item), notice: "出品しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    # 画像は未選択でも維持（何も編集しなくても画像が消えない条件に対応）
    if @item.update(item_params)
      redirect_to item_path(@item), notice: "更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_item
    @item = Item.with_attached_image.find(params[:id])
  end

  def redirect_unless_owner!
    redirect_to root_path unless current_user == @item.user
  end

  def item_params
    params.require(:item).permit(
      :image, :name, :info, :category_id, :sales_status_id,
      :shipping_fee_status_id, :prefecture_id, :scheduled_delivery_id, :price
    ).merge(user_id: current_user.id)
  end
end
