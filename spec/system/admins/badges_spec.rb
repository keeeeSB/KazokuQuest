require 'rails_helper'

RSpec.describe 'バッジ機能', type: :system do
  let(:admin) { create(:admin) }
  let!(:badge) do
    create(:badge,
           name: '初家事バッジ',
           description: '初めて家事を行ったユーザーに付与されるバッジ。',
           rule_type: 'task_count',
           rule_value: 1,
           enabled: true)
  end

  describe 'バッジ一覧' do
    before do
      create(:badge, name: '初育児バッジ', rule_type: 'task_count', enabled: true)
    end

    it '管理者は、バッジの一覧を閲覧できる' do
      login_as admin, scope: :admin
      visit admins_root_path

      click_link 'バッジ一覧'
      expect(page).to have_current_path admins_badges_path

      expect(page).to have_selector 'h2', text: 'バッジ一覧'

      within('tr', text: '初家事バッジ') do
        expect(page).to have_content '合計回数'
        expect(page).to have_content '有効'
      end

      within('tr', text: '初育児バッジ') do
        expect(page).to have_content '合計回数'
        expect(page).to have_content '有効'
      end
    end
  end

  describe 'バッジ詳細' do
    it '管理者は、バッジの詳細を閲覧できる' do
      login_as admin, scope: :admin
      visit admins_badges_path

      expect(page).to have_selector 'h2', text: 'バッジ一覧'

      within('tr', text: '初家事バッジ') do
        click_link '詳細'
      end

      expect(page).to have_current_path admins_badge_path(badge)
      expect(page).to have_selector 'h2', text: 'バッジ詳細'

      expect(page).to have_content '初家事バッジ'
      expect(page).to have_content '初めて家事を行ったユーザーに付与されるバッジ。'
      expect(page).to have_content '合計回数'
      expect(page).to have_content '1'
      expect(page).to have_content '有効'
    end
  end

  describe 'バッジ登録' do
    it '管理者は、バッジを登録できる' do
      login_as admin, scope: :admin
      visit admins_badges_path

      click_link 'バッジを追加'
      expect(page).to have_current_path new_admins_badge_path

      expect(page).to have_selector 'h2', text: 'バッジ登録'

      fill_in 'バッジ名', with: 'コツコツ名人'
      fill_in '説明', with: 'タスクを10回達成した人に送られるバッジ。'
      select '合計ポイント', from: '種別'
      fill_in '条件値', with: '10'
      check '有効'

      expect {
        click_button '登録する'
        expect(page).to have_content 'バッジを登録しました。'
        expect(page).to have_current_path admins_badge_path(Badge.last)
      }.to change(Badge, :count).by(1)

      expect(page).to have_selector 'h2', text: 'バッジ詳細'
      expect(page).to have_content 'コツコツ名人'
      expect(page).to have_content 'タスクを10回達成した人に送られるバッジ。'
      expect(page).to have_content '合計ポイント'
      expect(page).to have_content '10'
    end
  end

  describe 'バッジ編集' do
    it '管理者は、バッジの情報を編集できる' do
      login_as admin, scope: :admin
      visit admins_badge_path(badge)

      expect(page).to have_selector 'h2', text: 'バッジ詳細'
      expect(page).to have_content '初家事バッジ'
      expect(page).to have_content '初めて家事を行ったユーザーに付与されるバッジ。'
      expect(page).to have_content '合計回数'
      expect(page).to have_content '1'
      expect(page).to have_content '有効'

      click_link '編集する'
      expect(page).to have_current_path edit_admins_badge_path(badge)

      expect(page).to have_selector 'h2', text: 'バッジ編集'

      fill_in 'バッジ名', with: 'コツコツ名人'
      fill_in '説明', with: 'タスクを10回達成した人に送られるバッジ。'
      select '合計ポイント', from: '種別'
      fill_in '条件値', with: '10'
      uncheck '有効'
      click_button '更新する'

      expect(page).to have_content 'バッジ情報を更新しました。'
      expect(page).to have_current_path admins_badge_path(badge)

      expect(page).to have_selector 'h2', text: 'バッジ詳細'
      expect(page).to have_content 'コツコツ名人'
      expect(page).to have_content 'タスクを10回達成した人に送られるバッジ。'
      expect(page).to have_content '合計ポイント'
      expect(page).to have_content '10'
      expect(page).to have_content '無効'
    end
  end

  describe 'バッジ削除' do
    it '管理者は、バッジを削除できる' do
      login_as admin, scope: :admin
      visit admins_badge_path(badge)

      expect(page).to have_selector 'h2', text: 'バッジ詳細'
      expect(page).to have_content '初家事バッジ'
      expect(page).to have_content '初めて家事を行ったユーザーに付与されるバッジ。'
      expect(page).to have_content '合計回数'
      expect(page).to have_content '1'
      expect(page).to have_content '有効'

      expect {
        accept_confirm do
          click_button '削除する'
        end
        expect(page).to have_content 'バッジを削除しました。'
        expect(page).to have_current_path admins_badges_path
      }.to change(Badge, :count).by(-1)

      expect(page).to have_selector 'h2', text: 'バッジ一覧'

      expect(page).to have_content 'バッジがありません。'
      expect(page).not_to have_content '初家事バッジ'
    end
  end
end
