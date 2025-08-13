require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'User sign up' do
    context 'can register' do
      it 'is valid with all required attributes' do
        expect(user).to be_valid
      end

      it 'is valid when password is 6+ chars and alphanumeric' do
        user.password = user.password_confirmation = 'abc123'
        expect(user).to be_valid
      end
    end

    context 'cannot register (presence)' do
      it 'nickname blank' do
        user.nickname = ''
        user.validate
        expect(user.errors.full_messages).to include("Nickname can't be blank")
      end

      it 'email blank' do
        user.email = ''
        user.validate
        expect(user.errors.full_messages).to include("Email can't be blank")
      end

      it 'password blank' do
        user.password = ''
        user.password_confirmation = ''
        user.validate
        expect(user.errors.full_messages).to include("Password can't be blank")
      end

      it 'last_name blank' do
        user.last_name = ''
        user.validate
        expect(user.errors.full_messages).to include("Last name can't be blank")
      end

      it 'first_name blank' do
        user.first_name = ''
        user.validate
        expect(user.errors.full_messages).to include("First name can't be blank")
      end

      it 'last_name_kana blank' do
        user.last_name_kana = ''
        user.validate
        expect(user.errors.full_messages).to include("Last name kana can't be blank")
      end

      it 'first_name_kana blank' do
        user.first_name_kana = ''
        user.validate
        expect(user.errors.full_messages).to include("First name kana can't be blank")
      end

      it 'birth_date blank' do
        user.birth_date = nil
        user.validate
        expect(user.errors.full_messages).to include("Birth date can't be blank")
      end
    end

    context 'cannot register (email)' do
      it 'email taken' do
        user.save!
        another = build(:user, email: user.email)
        another.validate
        expect(another.errors.full_messages).to include('Email has already been taken')
      end

      it 'email without @ is invalid' do
        user.email = 'invalid.example.com'
        user.validate
        expect(user.errors.full_messages).to include('Email is invalid')
      end
    end

    context 'cannot register (password rules)' do
      it 'password too short (<=5)' do
        user.password = user.password_confirmation = 'a1a1a'
        user.validate
        expect(user.errors.full_messages)
          .to include('Password is too short (minimum is 6 characters)')
      end

      it 'password only letters' do
        user.password = user.password_confirmation = 'aaaaaa'
        user.validate
        expect(user.errors.full_messages)
          .to include('Password is invalid. Include both letters and numbers')
      end

      it 'password only numbers' do
        user.password = user.password_confirmation = '111111'
        user.validate
        expect(user.errors.full_messages)
          .to include('Password is invalid. Include both letters and numbers')
      end

      it 'password contains full-width chars' do
        user.password = user.password_confirmation = 'a１a１a１'
        user.validate
        expect(user.errors.full_messages)
          .to include('Password is invalid. Include both letters and numbers')
      end

      it 'password confirmation mismatch' do
        user.password = 'a1a1a1'
        user.password_confirmation = 'a1a1a2'
        user.validate
        expect(user.errors.full_messages)
          .to include("Password confirmation doesn't match Password")
      end
    end

    context 'cannot register (name formats)' do
      it 'last_name not full-width' do
        user.last_name = 'yamada'
        user.validate
        expect(user.errors.full_messages)
          .to include('Last name is invalid. Input full-width characters')
      end

      it 'first_name not full-width' do
        user.first_name = 'taro'
        user.validate
        expect(user.errors.full_messages)
          .to include('First name is invalid. Input full-width characters')
      end

      it 'last_name_kana not katakana (hiragana)' do
        user.last_name_kana = 'やまだ'
        user.validate
        expect(user.errors.full_messages)
          .to include('Last name kana is invalid. Input full-width katakana characters')
      end

      it 'first_name_kana not katakana (alphabet)' do
        user.first_name_kana = 'TARO'
        user.validate
        expect(user.errors.full_messages)
          .to include('First name kana is invalid. Input full-width katakana characters')
      end
    end
  end
end
