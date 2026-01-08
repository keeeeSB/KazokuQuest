require 'rails_helper'

RSpec.describe '家族登録機能', type: :system do
  let!(:user) { create(:user, name: 'アリス', email: 'alice@example.com', password: 'password12345', role: 'mother') }

  describe '家族登録' do
    context 'ログイン中・家族情報未登録の場合' do
      it 'ログイン後、家族登録ページに遷移され、家族情報を登録できる' do
        visit new_user_session_path
        expect(page).to have_selector 'h2', text: 'ログイン'

        fill_in 'メールアドレス', with: 'alice@example.com'
        fill_in 'パスワード', with: 'password12345'
        click_button 'ログインする'

        expect(page).to have_content '家族情報を登録してください。'
        expect(page).to have_current_path new_family_path

        expect(page).to have_selector 'h2', text: '家族登録'

        fill_in '苗字', with: '佐藤'

        expect {
          click_button '登録する'
          expect(page).to have_content '家族情報を登録しました。'
          expect(page).to have_current_path root_path
        }.to change(Family, :count).by(1)

        click_link 'アリス'
        expect(page).to have_current_path users_profile_path

        click_link '家族ページへ'
        expect(page).to have_current_path family_path

        expect(page).to have_selector 'h2', text: '佐藤家のページ'
      end
    end

    context 'ログイン中・家族情報登録済みの場合' do
      let(:family) { create(:family, name: '佐藤') }

      before do
        user.update!(family_id: family.id)
      end

      it 'ログイン後、ルートページに遷移される' do
        visit new_user_session_path
        expect(page).to have_selector 'h2', text: 'ログイン'

        fill_in 'メールアドレス', with: 'alice@example.com'
        fill_in 'パスワード', with: 'password12345'
        click_button 'ログインする'

        expect(page).to have_content 'ログインしました。'
        expect(page).to have_current_path root_path
      end
    end

    context 'ログインしていないユーザーの場合' do
      it '家族登録ページにアクセスできない' do
        visit new_family_path

        expect(page).to have_content 'ログインもしくはアカウント登録してください。'
        expect(page).to have_current_path user_session_path
        expect(page).to have_selector 'h2', text: 'ログイン'
      end
    end
  end
end
