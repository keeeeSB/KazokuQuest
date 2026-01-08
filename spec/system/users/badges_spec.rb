require 'rails_helper'

RSpec.describe 'バッジ取得機能', type: :system do
  let(:user) { create(:user, name: 'アリス') }

  before do
    create(:badge, name: 'はじめの一歩', description: '初めてタスクを行った人に送られるバッジ', rule_type: 'task_count', rule_category: nil, rule_value: 1)
    create(:badge, name: 'ファースト家事', description: '初めて家事タスクを行った人に送られるバッジ', rule_type: 'task_count', rule_category: 'housework', rule_value: 1)
    create(:badge, name: 'ファースト育児', description: '初めて育児タスクを行った人に送られるバッジ', rule_type: 'task_count', rule_category: 'childcare', rule_value: 1)
    create(:badge, name: '家事ビギナー', description: '家事タスクを5回行った人に送られるバッジ', rule_type: 'task_count', rule_category: 'housework', rule_value: 5)
    create(:task, name: '洗濯', category: 'housework')
  end

  describe 'バッジ一覧' do
    it 'ログイン中のユーザーは、取得したバッジの一覧を確認できる' do
      login_as user, scope: :user
      visit new_users_work_path

      expect(page).to have_selector 'h2', text: '作業登録'
      select '洗濯', from: 'タスク'
      fill_in '作業日', with: Date.new(2026, 1, 1)
      fill_in 'メモ', with: '多くて大変でした。'

      expect {
        click_button '登録する'
        expect(page).to have_content '作業を記録しました。'
        expect(page).to have_current_path users_work_path(Work.last)
      }.to change(user.works, :count).by(1)

      click_link 'アリス'
      expect(page).to have_current_path users_profile_path

      expect(page).to have_selector 'h2', text: 'アリスさんのプロフィール'
      expect(page).to have_selector 'h4', text: '獲得したバッジ'
      expect(page).to have_content 'はじめの一歩'
      expect(page).to have_content '初めてタスクを行った人に送られるバッジ'
      expect(page).to have_content 'ファースト家事'
      expect(page).to have_content '初めて家事タスクを行った人に送られるバッジ'
      expect(page).not_to have_content 'ファースト育児'
      expect(page).not_to have_content '家事ビギナー'
    end
  end
end
