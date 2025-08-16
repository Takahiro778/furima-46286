module ItemsHelper
  def postage_label(item)
    case item.postage_burden # 例: enum :postage_burden, { seller: 0, buyer: 1 }
    when "seller" then "送料込み(出品者負担)"
    when "buyer"  then "着払い(購入者負担)"
    else               "送料未設定"
    end
  end
end
