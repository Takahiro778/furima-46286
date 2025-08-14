# spec/models/item_spec.rb
require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:item) { build(:item) }

  describe '商品出品(Item)のバリデーション' do
    context '出品できるとき' do
      it '全ての必須項目が揃っていれば有効' do
        expect(item).to be_valid
      end
    end

    context '出品できないとき（必須）' do
      it 'nameが空だと無効' do
        item.name = ''
        item.valid?
        expect(item.errors.full_messages).to include("Name can't be blank")
      end

      it 'infoが空だと無効' do
        item.info = ''
        item.valid?
        expect(item.errors.full_messages).to include("Info can't be blank")
      end

      it 'imageが未添付だと無効' do
        item.image = nil
        item.valid?
        expect(item.errors.full_messages).to include("Image can't be blank")
      end
    end

    context 'ActiveHash選択（---を弾く）' do
      it 'category_idが1だと無効' do
        item.category_id = 1
        item.valid?
        expect(item.errors.full_messages).to include("Category can't be blank").or include("Category must be other than 1")
      end

      it 'sales_status_idが1だと無効' do
        item.sales_status_id = 1
        item.valid?
        expect(item.errors.full_messages).to include("Sales status can't be blank").or include("Sales status must be other than 1")
      end

      it 'shipping_fee_status_idが1だと無効' do
        item.shipping_fee_status_id = 1
        item.valid?
        expect(item.errors.full_messages).to include("Shipping fee status can't be blank").or include("Shipping fee status must be other than 1")
      end

      it 'prefecture_idが1だと無効' do
        item.prefecture_id = 1
        item.valid?
        expect(item.errors.full_messages).to include("Prefecture can't be blank").or include("Prefecture must be other than 1")
      end

      it 'scheduled_delivery_idが1だと無効' do
        item.scheduled_delivery_id = 1
        item.valid?
        expect(item.errors.full_messages).to include("Scheduled delivery can't be blank").or include("Scheduled delivery must be other than 1")
      end
    end

    context '価格のバリデーション' do
      it 'priceが空だと無効' do
        item.price = nil
        item.valid?
        expect(item.errors.full_messages).to include("Price can't be blank")
      end

      it 'priceが300未満だと無効' do
        item.price = 299
        item.valid?
        expect(item.errors.full_messages).to include('Price must be greater than or equal to 300')
      end

      it 'priceが9_999_999を超えると無効' do
        item.price = 10_000_000
        item.valid?
        expect(item.errors.full_messages).to include('Price must be less than or equal to 9999999')
      end

      it 'priceが整数以外（小数）だと無効' do
        item.price = 1000.5
        item.valid?
        expect(item.errors.full_messages).to include('Price must be an integer')
      end

      it 'priceが半角数字以外（全角や英字混在）だと無効' do
        item.price = '１０００' # 全角
        item.valid?
        # not_a_number / is not a number のどちらか
        expect(item.errors.full_messages.join).to match(/number/)
      end
    end
  end
end
