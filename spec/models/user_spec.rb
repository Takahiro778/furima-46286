require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'ユーザー新規登録' do
    context '登録できるとき' do
      it '必須項目がすべて揃っていれば有効' do
        expect(user).to be_valid
      end

      it 'パスワードが6文字以上かつ半角英数字混合なら有効' do
        user.password = user.password_confirmation = 'abc123'
        expect(user).to be_valid
      end
    end

    context '登録できないとき（必須）' do
      it 'nicknameが空' do
        user.nickname = ''
        user.validate
        expect(user.errors[:nickname]).to include('を入力してください')
      end

      it 'emailが空' do
        user.email = ''
        user.validate
        expect(user.errors[:email]).to include('を入力してください')
      end

      it 'passwordが空' do
        user.password = ''
        user.password_confirmation = ''
        user.validate
        expect(user.errors[:password]).to include('を入力してください')
      end

      it 'last_nameが空' do
        user.last_name = ''
        user.validate
        expect(user.errors[:last_name]).to include('を入力してください')
      end

      it 'first_nameが空' do
        user.first_name = ''
        user.validate
        expect(user.errors[:first_name]).to include('を入力してください')
      end

      it 'last_name_kanaが空' do
        user.last_name_kana = ''
        user.validate
        expect(user.errors[:last_name_kana]).to include('を入力してください')
      end

      it 'first_name_kanaが空' do
        user.first_name_kana = ''
        user.validate
        expect(user.errors[:first_name_kana]).to include('を入力してください')
      end

      it 'birth_dateが空' do
        user.birth_date = nil
        user.validate
        expect(user.errors[:birth_date]).to include('を入力してください')
      end
    end

    context '登録できないとき（email）' do
      it 'emailが重複' do
        user.save!
        another = build(:user, email: user.email)
        another.validate
        expect(another.errors[:email]).to include('はすでに存在します')
      end

      it '@を含まないemailは無効' do
        user.email = 'invalid.example.com'
        user.validate
        expect(user.errors[:email]).to include('は不正な値です')
      end
    end

    context '登録できないとき（パスワード）' do
      it 'passwordが5文字以下' do
        user.password = user.password_confirmation = 'a1a1a'
        user.validate
        expect(user.errors[:password]).to include('は6文字以上で入力してください')
      end

      it '英字のみのpasswordは無効' do
        user.password = user.password_confirmation = 'aaaaaa'
        user.validate
        expect(user.errors[:password]).to include('は半角英数字混合で入力してください')
      end

      it '数字のみのpasswordは無効' do
        user.password = user.password_confirmation = '111111'
        user.validate
        expect(user.errors[:password]).to include('は半角英数字混合で入力してください')
      end

      it '全角を含むpasswordは無効' do
        user.password = user.password_confirmation = 'a１a１a１'
        user.validate
        expect(user.errors[:password]).to include('は半角英数字混合で入力してください')
      end

      it 'passwordとpassword_confirmationが不一致' do
        user.password = 'a1a1a1'
        user.password_confirmation = 'a1a1a2'
        user.validate
        expect(user.errors[:password_confirmation]).to include('とパスワードの入力が一致しません')
      end
    end

    context '登録できないとき（氏名の形式）' do
      it 'last_nameが全角以外' do
        user.last_name = 'yamada'
        user.validate
        expect(user.errors[:last_name]).to include('は全角（漢字・ひらがな・カタカナ）で入力してください')
      end

      it 'first_nameが全角以外' do
        user.first_name = 'taro'
        user.validate
        expect(user.errors[:first_name]).to include('は全角（漢字・ひらがな・カタカナ）で入力してください')
      end

      it 'last_name_kanaが全角カタカナ以外（ひらがな）' do
        user.last_name_kana = 'やまだ'
        user.validate
        expect(user.errors[:last_name_kana]).to include('は全角（カタカナ）で入力してください')
      end

      it 'first_name_kanaが全角カタカナ以外（英字）' do
        user.first_name_kana = 'TARO'
        user.validate
        expect(user.errors[:first_name_kana]).to include('は全角（カタカナ）で入力してください')
      end
    end
  end
end
