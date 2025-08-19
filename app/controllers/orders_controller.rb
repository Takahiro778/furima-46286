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
      begin
        pay_item
        ApplicationRecord.transaction { @order_shipping_address.save }
        redirect_to root_path, notice: '購入が完了しました'
      rescue => e
        Rails.logger.error("[PAYJP] charge failed: #{e.class} #{e.message}")
        flash.now[:alert] = '決済に失敗しました。時間をおいて再度お試しください。'
        render :index, status: :unprocessable_entity
      end
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end

  def redirect_if_invalid
    redirect_to root_path if @item.order.present? || @item.user_id == current_user.id
  end

  def order_params
    params.require(:order_shipping_address).permit(
      :postal_code, :prefecture_id, :city, :addresses, :building, :phone_number, :token
    ).merge(user_id: current_user.id, item_id: @item.id)
  end

  # PAY.JP 課金処理
  def pay_item
    secret = ENV['PAYJP_SECRET_KEY']
    token  = params.dig(:order_shipping_address, :token) || order_params[:token]

    # 学習用に秘密鍵が無い場合は課金スキップ
    if secret.blank?
      Rails.logger.info('[PAYJP] SECRETキー未設定のため決済をスキップ（学習モード）')
      return true
    end
    raise 'card token missing' if token.blank?

    begin
      require 'payjp'
    rescue LoadError
      # gem をコメントアウトしている環境でも原因が分かるように明示
      raise 'payjp gem not loaded. Please add gem "payjp" and run bundle install.'
    end

    Payjp.api_key = secret
    Payjp::Charge.create(amount: @item.price, card: token, currency: 'jpy')
  end
end
