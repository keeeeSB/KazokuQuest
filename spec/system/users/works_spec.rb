require 'rails_helper'

RSpec.describe '作業機能', type: :system do
  let(:user) { create(:user, name: 'アリス') }
  let!(:task) { create(:task, name: 'おむつ交換', category: 'childcare', point: 5) }
  let(:work) { create(:work, user:, task:, done_on: '2025-12-01') }

  before do
    create(:task, name: '洗濯', category: 'housework', point: 3)
  end

  describe '作業詳細' do
    it 'ログイン中のユーザーは、作業の詳細を閲覧できる' do
      login_as user, scope: :user
      visit users_work_path(work)

      expect(page).to have_selector 'h2', text: '作業詳細'
      expect(page).to have_content '作業日： 2025年12月1日'
      expect(page).to have_content '作業者： アリス'
      expect(page).to have_content 'タスク： おむつ交換'
      expect(page).to have_content '育児'
      expect(page).to have_content '点数： 5'
    end
  end

  describe '作業登録' do
    it 'ログイン中のユーザーは、作業を登録できる' do
      login_as user, scope: :user
      visit root_path

      click_link '作業登録'
      expect(page).to have_current_path new_users_work_path

      expect(page).to have_selector 'h2', text: '作業登録'
      select '洗濯', from: 'タスク'
      fill_in '作業日', with: Date.new(2025, 12, 1)
      fill_in 'メモ', with: '多くて大変でした。'
      expect {
        click_button '登録する'
        expect(page).to have_content '作業を記録しました。'
      }.to change(user.works, :count).by(1)

      work = user.works.last

      expect(page).to have_current_path users_work_path(work)
      expect(page).to have_selector 'h2', text: '作業詳細'
      expect(page).to have_content '作業日： 2025年12月1日'
      expect(page).to have_content '作業者： アリス'
      expect(page).to have_content 'タスク： 洗濯'
      expect(page).to have_content '家事'
      expect(page).to have_content '点数： 3'
      expect(page).to have_content '多くて大変でした。'
    end
  end

  describe '作業編集' do
    it 'ログイン中の作業登録者は、作業内容を編集できる' do
      login_as user, scope: :user
      visit users_work_path(work)

      expect(page).to have_selector 'h2', text: '作業詳細'
      expect(page).to have_content '作業日： 2025年12月1日'
      expect(page).to have_content '作業者： アリス'
      expect(page).to have_content 'タスク： おむつ交換'
      expect(page).to have_content '育児'
      expect(page).to have_content '点数： 5'

      click_link '編集'
      expect(page).to have_current_path edit_users_work_path(work)

      expect(page).to have_selector 'h2', text: '作業編集'
      select '洗濯', from: 'タスク'
      fill_in '作業日', with: Date.new(2025, 12, 10)
      fill_in 'メモ', with: '多くて大変でした。'
      click_button '更新する'

      work = user.works.last

      expect(page).to have_content '作業内容を更新しました。'
      expect(page).to have_current_path users_work_path(work)
      expect(page).to have_content '作業日： 2025年12月10日'
      expect(page).to have_content '作業者： アリス'
      expect(page).to have_content 'タスク： 洗濯'
      expect(page).to have_content '家事'
      expect(page).to have_content '多くて大変でした。'
    end
  end

  describe '作業削除' do
    it 'ログイン中の作業登録者は、作業を削除できる' do
      login_as user, scope: :user
      visit users_work_path(work)

      expect(page).to have_selector 'h2', text: '作業詳細'
      expect(page).to have_content '作業日： 2025年12月1日'
      expect(page).to have_content '作業者： アリス'
      expect(page).to have_content 'タスク： おむつ交換'
      expect(page).to have_content '育児'
      expect(page).to have_content '点数： 5'

      expect {
        accept_confirm do
          click_button '削除'
        end
        expect(page).to have_content '作業を削除しました。'
        expect(page).to have_current_path root_path
      }.to change(user.works, :count).by(-1)
    end
  end
end
