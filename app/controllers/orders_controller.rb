class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item
  before_action :redirect_if_invalid

  def index
    @order_shipping_address = OrderShippingAddress.new
  end

  def create
    @order_shipping_address = OrderShippingAddress.new(order_params)
    if @order_shipping_address.valid?
      ApplicationRecord.transaction do
        pay_item        # ← 今はPAY.JP未導入でもスキップできるように実装（下記）
        @order_shipping_address.save
      end
      redirect_to root_path, notice: '購入が完了しました'
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end

  # 出品者自身/売却済みは購入不可
  def redirect_if_invalid
    redirect_to root_path if @item.order.present? || @item.user_id == current_user.id
  end

  def order_params
    params.require(:order_shipping_address).permit(
      :postal_code, :prefecture_id, :city, :addresses, :building, :phone_number, :token
    ).merge(user_id: current_user.id, item_id: @item.id)
  end

  # ==== 決済処理（PAY.JPが無ければ安全にスキップ）====
  def pay_item
    return true unless ENV['PAYJP_SECRET_KEY'].present?
    begin
      require 'payjp'
    rescue LoadError
      Rails.logger.info('[PAYJP] gem not loaded. Skipping charge in dev.')
      return true
    end
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    Payjp::Charge.create(
      amount: @item.price,
      card:   params[:order_shipping_address][:token],
      currency: 'jpy'
    )
  end
end
