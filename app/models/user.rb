# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ZENKAKU_REGEX = /\A[ぁ-んァ-ヶ一-龥々ー]+\z/
  KATAKANA_REGEX = /\A[ァ-ヶー]+\z/
  PW_COMPLEXITY = /\A(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]+\z/

  validates :nickname, :last_name, :first_name,
            :last_name_kana, :first_name_kana, :birth_date, presence: true

  validates :last_name, :first_name, format: { with: ZENKAKU_REGEX, message: 'は全角で入力してください' }
  validates :last_name_kana, :first_name_kana, format: { with: KATAKANA_REGEX, message: 'は全角カタカナで入力してください' }

  # Deviseのlengthは6以上。半角英数字混合だけ追加で担保
  validates :password, format: { with: PW_COMPLEXITY, message: 'は半角英数字混合で入力してください' }, if: :password_required?
end
