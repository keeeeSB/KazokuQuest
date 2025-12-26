require 'rails_helper'

RSpec.describe '家族の一日の記録機能', type: :system do
  let(:family) { create(:family, name: '佐藤') }
  let(:alice) { create(:user, family:, name: 'アリス') }
  let(:bob) { create(:user, family:, name: 'ボブ') }

  before do
    diaper_task = create(:task, name: 'おむつ交換', category: 'childcare', point: 5)
    laundry_task = create(:task, name: '洗濯', category: 'housework', point: 3)

    create(:work, user: alice, task: diaper_task, done_on: Date.current)
    create(:work, user: alice, task: laundry_task, done_on: Date.current)
    create(:work, user: bob, task: laundry_task, done_on: Date.current)
  end

  describe '1日の記録詳細' do
    it 'ログイン中のユーザーは、家族の1日の記録を閲覧できる' do
      login_as alice, scope: :user
      visit root_path

      expect(page).to have_selector 'h2', text: '今日の家族の記録'

      within("[data-test-id='daily-record-#{alice.id}']") do
        expect(page).to have_selector 'h4', text: 'アリスさん'
        expect(page).to have_content 'おむつ交換 : 5'
        expect(page).to have_content '洗濯 : 3'
        expect(page).to have_content '合計ポイント: 8'
      end

      within("[data-test-id='daily-record-#{bob.id}']") do
        expect(page).to have_selector 'h4', text: 'ボブさん'
        expect(page).to have_content '洗濯 : 3'
        expect(page).to have_content '合計ポイント: 3'
      end
    end
  end
end
