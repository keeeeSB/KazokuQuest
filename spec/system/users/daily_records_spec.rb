require 'rails_helper'

RSpec.describe '一日の記録機能', type: :system do
  let(:user) { create(:user) }

  before do
    diaper_task = create(:task, name: 'おむつ交換', category: 'childcare', point: 5)
    laundry_task = create(:task, name: '洗濯', category: 'housework', point: 3)

    create(:work, user: user, task: diaper_task, done_on: Date.current)
    create(:work, user: user, task: laundry_task, done_on: Date.current)
  end

  describe '1日の記録詳細' do
    it 'ログイン中のユーザーは、1日の記録を閲覧できる' do
      login_as user, scope: :user
      visit root_path

      click_link '今日の記録'
      expect(page).to have_current_path users_daily_record_path(date: Date.current)

      expect(page).to have_content 'おむつ交換'
      expect(page).to have_content '洗濯'
      expect(page).to have_content '合計ポイント: 8'
    end
  end
end
