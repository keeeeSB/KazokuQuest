require 'rails_helper'

RSpec.describe '家族招待機能', type: :system do
  let(:family) { create(:family, name: '佐藤') }
  let!(:invitation) { create(:family_invitation, family:, email: 'bob@example.com', token: 'a * 32', expires_at: 1.day.from_now) }

  before do
    create(:user, family:, name: 'アリス', role: 'mother')
  end

  describe '家族招待' do
    context '招待されたユーザーが、ユーザー登録をしていない場合' do
      before do
        FamilyInvitationMailer.invite(invitation).deliver_now
      end

      it '家族招待されたユーザーは、ユーザー登録後、家族情報を登録できる' do
        email = open_last_email

        expect(email.subject).to eq '【KazokuQuest】家族招待のお知らせ'
        click_first_link_in_email(email)

        expect(page).to have_content 'ユーザー登録を行なってください。'
        expect(page).to have_current_path new_user_registration_path

        expect(page).to have_selector 'h2', text: '新規登録'
        fill_in 'お名前', with: 'ボブ'
        fill_in 'メールアドレス', with: 'bob@example.com'
        fill_in 'パスワード', with: 'password12345', match: :prefer_exact
        fill_in 'パスワード（確認用）', with: 'password12345'
        select 'パパ', from: '続柄'

        expect {
          click_button '登録する'
          expect(page).to have_content '本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。'
          expect(page).to have_current_path root_path
        }.to change(User, :count).by(1)

        email = open_last_email

        expect(email.subject).to eq 'メールアドレス確認メール'
        click_first_link_in_email(email)

        expect(page).to have_content 'メールアドレスが確認できました。'
        expect(page).to have_current_path new_user_session_path

        expect(page).to have_selector 'h2', text: 'ログイン'

        fill_in 'メールアドレス', with: 'bob@example.com'
        fill_in 'パスワード', with: 'password12345'
        click_button 'ログインする'

        expect(page).to have_content '家族情報を登録しました。'
        expect(page).to have_current_path family_path

        expect(page).to have_selector 'h2', text: '佐藤家のページ'
        within('.card') do
          expect(page).to have_content 'アリス'
          expect(page).to have_content 'ママ'
          expect(page).to have_content 'ボブ'
          expect(page).to have_content 'パパ'
        end
      end
    end

    context '招待されたユーザーが、ユーザー登録済み、未ログインの場合' do
      before do
        FamilyInvitationMailer.invite(invitation).deliver_now
        create(:user, family: nil, name: 'ボブ', role: 'father', email: 'bob@example.com', password: 'password12345')
      end

      it '家族招待されたユーザーは、ログイン後、家族情報を登録できる' do
        email = open_last_email

        expect(email.subject).to eq '【KazokuQuest】家族招待のお知らせ'
        click_first_link_in_email(email)

        expect(page).to have_content 'ユーザー登録を行なってください。'
        expect(page).to have_current_path new_user_registration_path

        expect(page).to have_selector 'h2', text: '新規登録'

        click_link 'ログイン'
        expect(page).to have_current_path new_user_session_path

        expect(page).to have_selector 'h2', text: 'ログイン'
        fill_in 'メールアドレス', with: 'bob@example.com'
        fill_in 'パスワード', with: 'password12345'
        click_button 'ログインする'

        expect(page).to have_content '家族情報を登録しました。'
        expect(page).to have_current_path family_path

        expect(page).to have_selector 'h2', text: '佐藤家のページ'
        within('.card') do
          expect(page).to have_content 'アリス'
          expect(page).to have_content 'ママ'
          expect(page).to have_content 'ボブ'
          expect(page).to have_content 'パパ'
        end
      end
    end

    context '招待されたユーザーが、ログイン中の場合' do
      let(:user) { create(:user, family: nil, name: 'ボブ', email: 'bob@example.com') }

      before do
        FamilyInvitationMailer.invite(invitation).deliver_now
      end

      it '家族情報を登録できる' do
        login_as user, scope: :user
        visit root_path

        email = open_last_email

        expect(email.subject).to eq '【KazokuQuest】家族招待のお知らせ'
        click_first_link_in_email(email)

        expect(page).to have_content '家族情報を登録しました。'
        expect(page).to have_current_path family_path

        expect(page).to have_selector 'h2', text: '佐藤家のページ'
        within('.card') do
          expect(page).to have_content 'アリス'
          expect(page).to have_content 'ママ'
          expect(page).to have_content 'ボブ'
          expect(page).to have_content 'パパ'
        end
      end
    end
  end
end
