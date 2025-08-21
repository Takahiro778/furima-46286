# spec/models/order_shipping_address_spec.rb
require 'rails_helper'

RSpec.describe OrderShippingAddress, type: :model do
  before do
    @user = create(:user)
    @item = create(:item)
    @form = build(:order_shipping_address, user_id: @user.id, item_id: @item.id)
  end

  describe '購入情報の保存' do
    context '内容に問題がないとき' do
      it '全ての値が正しければ保存できる' do
        expect(@form).to be_valid
      end

      it 'buildingが空でも保存できる' do
        @form.building = ''
        expect(@form).to be_valid
      end
    end

    context '内容に問題があるとき' do
      it 'tokenが空だと保存できない' do
        @form.token = ''
        @form.valid?
        expect(@form.errors.full_messages)
          .to include("Token can't be blank")
      end

      it 'postal_codeが空だと保存できない' do
        @form.postal_code = ''
        @form.valid?
        expect(@form.errors.full_messages)
          .to include("Postal code can't be blank")
      end

      it 'postal_codeがハイフン無しだと保存できない' do
        @form.postal_code = '1234567'
        @form.valid?
        expect(@form.errors.full_messages)
          .to include('Postal code is invalid. Enter it as follows (e.g. 123-4567)')
      end

      it 'prefecture_idが1(---)だと保存できない' do
        @form.prefecture_id = 1
        @form.valid?
        expect(@form.errors.full_messages)
          .to include("Prefecture can't be blank")
      end

      it 'cityが空だと保存できない' do
        @form.city = ''
        @form.valid?
        expect(@form.errors.full_messages)
          .to include("City can't be blank")
      end

      it 'addressesが空だと保存できない' do
        @form.addresses = ''
        @form.valid?
        expect(@form.errors.full_messages)
          .to include("Addresses can't be blank")
      end

      it 'phone_numberが空だと保存できない' do
        @form.phone_number = ''
        @form.valid?
        expect(@form.errors.full_messages)
          .to include("Phone number can't be blank")
      end

      it 'phone_numberが9桁以下だと保存できない' do
        @form.phone_number = '090123456'
        @form.valid?
        expect(@form.errors.full_messages)
          .to include('Phone number is too short')
      end

      it 'phone_numberが12桁以上だと保存できない' do
        @form.phone_number = '090123456789'
        @form.valid?
        expect(@form.errors.full_messages)
          .to include('Phone number is too long')
      end

      it 'phone_numberにハイフンがあると保存できない' do
        @form.phone_number = '090-1234-5678'
        @form.valid?
        expect(@form.errors.full_messages)
          .to include('Phone number is invalid. Input only number')
      end

      it 'user_idが無いと保存できない' do
        @form.user_id = nil
        @form.valid?
        expect(@form.errors.full_messages).to include("User can't be blank")
      end

      it 'item_idが無いと保存できない' do
        @form.item_id = nil
        @form.valid?
        expect(@form.errors.full_messages).to include("Item can't be blank")
      end

      it 'エラーメッセージが重複しない（phone_numberの例）' do
        @form.phone_number = 'abc'
        @form.valid?
        msgs = @form.errors.full_messages.select { |m| m.include?('Phone number') }
        expect(msgs.uniq.size).to eq(msgs.size)
      end
    end
  end
end
