require 'rails_helper'

RSpec.describe 'タスク機能', type: :system do
  let(:admin) { create(:admin) }
  let!(:task) { create(:task, name: '掃除', category: 'housework', point: 3) }

  describe 'タスク一覧' do
    it '管理者は、タスクの一覧を閲覧できる' do
      login_as admin, scope: :admin
      visit admins_root_path

      click_link 'タスク一覧'
      expect(page).to have_current_path admins_tasks_path

      expect(page).to have_selector 'h2', text: 'タスク一覧'
      within('tr', text: '掃除') do
        expect(page).to have_content '家事'
        expect(page).to have_content '3'
      end
    end
  end

  describe 'タスク詳細' do
    it '管理者は、タスクの詳細を閲覧できる' do
      login_as admin, scope: :admin
      visit admins_tasks_path

      within('tr', text: '掃除') do
        expect(page).to have_content '家事'
        click_link '詳細'
      end

      expect(page).to have_current_path admins_task_path(task)

      expect(page).to have_selector 'h2', text: 'タスク詳細'
      expect(page).to have_content '掃除'
      expect(page).to have_content '家事'
      expect(page).to have_content '3'
    end
  end

  describe 'タスク作成' do
    it '管理者は、タスクを作成できる' do
      login_as admin, scope: :admin
      visit admins_tasks_path

      click_link 'タスクを追加'
      expect(page).to have_current_path new_admins_task_path

      fill_in 'タスク名', with: 'おむつ交換'
      select '育児', from: 'カテゴリー'
      fill_in '点数', with: '5'

      expect {
        click_button '登録する'
        expect(page).to have_content 'タスクを作成しました。'
      }.to change(Task, :count).by(1)

      task = Task.last

      expect(page).to have_current_path admins_task_path(task)
      expect(page).to have_selector 'h2', text: 'タスク詳細'
      expect(page).to have_content 'おむつ交換'
      expect(page).to have_content '育児'
      expect(page).to have_content '5'
    end
  end

  describe 'タスク編集' do
    it '管理者は、タスクを編集できる' do
      login_as admin, scope: :admin
      visit admins_tasks_path

      expect(page).to have_selector 'h2', text: 'タスク一覧'
      within('tr', text: '掃除') do
        expect(page).to have_content '家事'
        expect(page).to have_content '3'
        click_link '編集'
      end

      expect(page).to have_current_path edit_admins_task_path(task)
      expect(page).to have_selector 'h2', text: 'タスク編集'

      fill_in 'タスク名', with: 'おむつ交換'
      select '育児', from: 'カテゴリー'
      fill_in '点数', with: '5'
      click_button '更新する'

      expect(page).to have_content 'タスクを更新しました。'
      expect(page).to have_current_path admins_task_path(task)

      expect(page).to have_selector 'h2', text: 'タスク詳細'
      expect(page).to have_content 'おむつ交換'
      expect(page).to have_content '育児'
      expect(page).to have_content '5'
    end
  end

  describe 'タスク削除' do
    it '管理者は、タスクを削除できる' do
      login_as admin, scope: :admin
      visit admins_task_path(task)

      expect(page).to have_selector 'h2', text: 'タスク詳細'
      expect(page).to have_content '掃除'
      expect(page).to have_content '家事'
      expect(page).to have_content '3'

      expect {
        accept_confirm do
          click_button '削除する'
        end
        expect(page).to have_content 'タスクを削除しました。'
        expect(page).to have_current_path admins_tasks_path
      }.to change(Task, :count).by(-1)

      expect(page).to have_selector 'h2', text: 'タスク一覧'
      expect(page).to have_content 'タスクがありません。'
    end
  end
end
