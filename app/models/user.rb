# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ZENKAKU_REGEX   = /\A[ぁ-んァ-ヶ一-龥々ー]+\z/
  KATAKANA_REGEX  = /\A[ァ-ヶー]+\z/
  PW_COMPLEXITY   = /\A(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]+\z/

  validates :nickname, :last_name, :first_name,
            :last_name_kana, :first_name_kana, :birth_date, presence: true

  # ← ここを英語の message に
  validates :last_name,
            format: { with: ZENKAKU_REGEX,  message: 'is invalid. Input full-width characters' }
  validates :first_name,
            format: { with: ZENKAKU_REGEX,  message: 'is invalid. Input full-width characters' }
  validates :last_name_kana,
            format: { with: KATAKANA_REGEX, message: 'is invalid. Input full-width katakana characters' }
  validates :first_name_kana,
            format: { with: KATAKANA_REGEX, message: 'is invalid. Input full-width katakana characters' }

  validates :password,
            format: { with: PW_COMPLEXITY,
                      message: 'is invalid. Include both letters and numbers' },
            if: :password_required?
end
