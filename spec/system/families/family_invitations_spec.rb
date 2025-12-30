require 'rails_helper'

RSpec.describe '家族招待機能', type: :system do
  let(:family) { create(:family, name: '佐藤') }
  let(:user) { create(:user, family:, name: 'アリス', role: 'mother') }

  describe '家族招待' do
    context 'ログイン中のユーザーの場合' do
      it '家族招待メールを送信できる' do
        login_as user, scope: :user
        visit family_path

        expect(page).to have_selector 'h2', text: '佐藤家のページ'
        within('.card') do
          expect(page).to have_content 'アリス'
          expect(page).to have_content 'ママ'
          expect(page).to have_link '家族を招待する'

          click_link '家族を招待する'
        end

        expect(page).to have_current_path new_family_family_invitation_path
        expect(page).to have_selector 'h2', text: '家族招待'

        fill_in 'メールアドレス', with: 'bob@example.com'
        expect {
          click_button '招待する'
          expect(page).to have_content '家族招待メールを送信しました。'
          expect(page).to have_current_path family_path
        }.to change(FamilyInvitation, :count).by(1)

        email = open_last_email

        expect(email.subject).to eq '【KazokuQuest】家族招待のお知らせ'
        expect(email.html_part.body.decoded).to have_content 'KazokuQuest への家族招待が届いています。'
      end
    end

    context '未ログインのユーザーの場合' do
      it '家族招待ページにアクセスできない' do
        visit new_family_family_invitation_path

        expect(page).to have_content 'ログインもしくはアカウント登録してください。'
        expect(page).to have_current_path new_user_session_path
      end
    end
  end
end
