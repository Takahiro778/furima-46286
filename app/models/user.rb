class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ZENKAKU_REGEX = /\A[ぁ-んァ-ヶ一-龥々ー]+\z/
  KATAKANA_REGEX = /\A[ァ-ヶー]+\z/
  PW_COMPLEXITY = /\A(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]+\z/

    validates :nickname, :last_name, :first_name,
            :last_name_kana, :first_name_kana, :birth_date, presence: true

  validates :last_name, :first_name, format: { with: ZENKAKU_REGEX, message: 'は全角（漢字・ひらがな・カタカナ）で入力してください' }
  validates :last_name_kana, :first_name_kana, format: { with: KATAKANA_REGEX, message: 'は全角（カタカナ）で入力してください' }

  # Deviseのバリデーション（presence, length）に加えて、フォーマット（英数字混合）のバリデーションを追加
  # allow_blank: true を設定し、presenceチェックはDeviseに任せることで、エラーメッセージの重複を防ぐ
  validates :password, format: { with: PW_COMPLEXITY, message: 'は半角英数字混合で入力してください' }, allow_blank: true, if: :password_required?
end


