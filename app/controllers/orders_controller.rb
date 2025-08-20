class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item
  before_action :redirect_if_seller_or_sold
  before_action :set_payjp_key, only: [:index, :create]

  def index
    @order_shipping_address = OrderShippingAddress.new
  end

  def create
    @order_shipping_address = OrderShippingAddress.new(order_shipping_address_params)
    if @order_shipping_address.valid?
      pay_item
      @order_shipping_address.save
      redirect_to root_path
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_payjp_key
    gon.payjp_public_key = ENV['PAYJP_PUBLIC_KEY']
  end

  def set_item
    @item = Item.find(params[:item_id])
  end

  def redirect_if_seller_or_sold
    redirect_to root_path if current_user.id == @item.user_id || @item.order.present?
  end

  def order_shipping_address_params
    params.require(:order_shipping_address).permit(
      :postal_code, :prefecture_id, :city, :addresses, :building, :phone_number
    ).merge(user_id: current_user.id, item_id: @item.id, token: params[:token])
  end


  def pay_item
    # 秘密鍵は config/initializers/payjp.rb で設定済みのため、この記述は不要
    Payjp::Charge.create(
      amount:   @item.price,
      card:     order_shipping_address_params[:token],  # Strong Parameters を通した安全なトークンを使用
      currency: 'jpy'
    )
  end


end
